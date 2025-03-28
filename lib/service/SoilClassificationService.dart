import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:math';

class SoilClassificationService {
  List<double> rgbToHls(int r, int g, int b) {
    double rNorm = r / 255.0;
    double gNorm = g / 255.0;
    double bNorm = b / 255.0;

    double maxVal = max(rNorm, max(gNorm, bNorm));
    double minVal = min(rNorm, min(gNorm, bNorm));
    double h = 0.0, l = (maxVal + minVal) / 2, s = 0.0;

    if (maxVal != minVal) {
      double delta = maxVal - minVal;
      s = l > 0.5 ? delta / (2.0 - maxVal - minVal) : delta / (maxVal + minVal);
      if (maxVal == rNorm) {
        h = (gNorm - bNorm) / delta + (gNorm < bNorm ? 6.0 : 0.0);
      } else if (maxVal == gNorm) {
        h = (bNorm - rNorm) / delta + 2.0;
      } else {
        h = (rNorm - gNorm) / delta + 4.0;
      }
      h /= 6.0;
    }
    return [h, l, s];
  }

  Future<Map<String, double>> getTextureFeatures(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists())
      throw Exception("Error: Unable to read image at '$imagePath'");

    img.Image? image = img.decodeImage(await file.readAsBytes());
    if (image == null) throw Exception("Error: Unable to decode image");

    img.Image grayImage = img.grayscale(image);
    int width = grayImage.width, height = grayImage.height;
    double contrast = 0.0, homogeneity = 0.0;

    List<int> intensities = [];
    int totalIntensity = 0;
    int numPixels = 0;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int intensity = grayImage.getPixel(x, y).luminance.toInt();
        intensities.add(intensity);
        totalIntensity += intensity;
        numPixels++;
      }
    }

    double mean = totalIntensity / numPixels;
    double sumSquaredDifferences = 0.0;

    for (int intensity in intensities) {
      sumSquaredDifferences += (intensity - mean) * (intensity - mean);
    }
    contrast = sqrt(sumSquaredDifferences / numPixels) / 255.0;

    for (int y = 1; y < height; y++) {
      for (int x = 1; x < width; x++) {
        int intensity = grayImage.getPixel(x, y).luminance.toInt();
        int prevIntensity = grayImage.getPixel(x - 1, y - 1).luminance.toInt();
        homogeneity += 1.0 / (1 + (intensity - prevIntensity).abs());
      }
    }
    homogeneity /= (width * height);

    return {'contrast': contrast, 'homogeneity': homogeneity};
  }

  Future<List<int>> getDominantColor(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists())
      throw Exception("Error: Unable to read image at '$imagePath'");

    img.Image? image = img.decodeImage(await file.readAsBytes());
    if (image == null) throw Exception("Error: Unable to decode image");

    Map<int, int> colorCount = {};
    for (int y = 0; y < image.height; y += 5) {
      for (int x = 0; x < image.width; x += 5) {
        img.Pixel pixel = image.getPixel(x, y);

        int r = pixel.r.toInt();
        int g = pixel.g.toInt();
        int b = pixel.b.toInt();

        int color = (r << 16) | (g << 8) | b;
        colorCount[color] = (colorCount[color] ?? 0) + 1;
      }
    }

    int dominantColor =
        colorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return [
      (dominantColor >> 16) & 0xFF,
      (dominantColor >> 8) & 0xFF,
      dominantColor & 0xFF,
    ];
  }

  Map<String, double> getSoilComposition(
    double contrast,
    double homogeneity,
    String soilColor,
  ) {
    //debug
    print('Contrast: $contrast, Homogeneity: $homogeneity');

    if (soilColor == "White/Pale/Bleached" &&
        contrast > 0.5 &&
        homogeneity < 0.4) {
      return {"Sand": 90, "Silt": 5, "Clay": 5};
    } else if (soilColor == "White/Pale/Bleached" &&
        contrast < 0.5 &&
        homogeneity > 0.4) {
      return {"Sand": 80, "Silt": 15, "Clay": 5};
    } else if ((soilColor == "Red" || soilColor == "Yellow to Yellow-Brown") &&
        contrast > 0.2) {
      return {"Sand": 80, "Silt": 10, "Clay": 10};
    } else if (soilColor == "Brown" &&
        contrast > 0.2 &&
        contrast < 0.5 &&
        homogeneity > 0.1 &&
        homogeneity < 0.4) {
      return {"Sand": 50, "Silt": 30, "Clay": 20};
    } else if ((soilColor == "Black" || soilColor == "Grey/Green/Gleyed") &&
        contrast < 0.15 &&
        homogeneity > 0.5) {
      return {"Sand": 20, "Silt": 30, "Clay": 50};
    } else if (contrast > 0.4 && homogeneity < 0.5) {
      return {"Sand": 70, "Silt": 20, "Clay": 10};
    }

    return {"Sand": 30, "Silt": 60, "Clay": 10};
  }

  String classifySoilType(Map<String, double> composition) {
    double sand = composition['Sand'] ?? 0;
    double silt = composition['Silt'] ?? 0;
    double clay = composition['Clay'] ?? 0;
    double total = sand + silt + clay;

    if (total > 0) {
      sand /= total;
      silt /= total;
      clay /= total;
    }

    if (clay > 0.45) return "Clayey Soil";
    if (silt > 0.50) return "Silty Soil";
    if (sand > 0.85) return "Sandy Soil";
    if (sand > 0.70) return "Sandy Loam";

    return "Loamy Soil";
  }

  String determineMoistureLevel(List<int> rgb) {
    double lightness = rgbToHls(rgb[0], rgb[1], rgb[2])[1];
    if (lightness < 0.3) return "High";
    if (lightness < 0.6) return "Medium";
    return "Low";
  }

  String matchSoilColor(List<int> rgb) {
    Map<String, List<List<int>>> colorMap = {
      "Black": [
        [0, 0, 0],
        [85, 85, 85],
      ],
      "White/Pale/Bleached": [
        [170, 150, 130],
        [255, 255, 255],
      ],
      "Red": [
        [120, 30, 20],
        [255, 130, 110],
      ],
      "Yellow to Yellow-Brown": [
        [150, 100, 50],
        [240, 200, 120],
      ],
      "Brown": [
        [70, 40, 20],
        [210, 160, 110],
      ],
      "Grey/Green/Gleyed": [
        [60, 60, 60],
        [170, 170, 170],
      ],
    };

    return colorMap.entries
        .map((entry) {
          List<int> midpoint = [
            for (int i = 0; i < 3; i++)
              (entry.value[0][i] + entry.value[1][i]) ~/ 2,
          ];
          double distance = sqrt(
            midpoint
                .asMap()
                .entries
                .map((e) => pow(rgb[e.key] - e.value, 2))
                .reduce((a, b) => a + b),
          );
          return MapEntry(entry.key, distance);
        })
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
  }

  String matchSoilType(List<int> rgb, String texture) {
    Map<String, List<List<int>>> colorMap = {
      "Clayey Soil": [
        [0, 0, 0],
        [85, 85, 85],
      ],
      "Sandy Soil": [
        [170, 150, 130],
        [255, 255, 255],
        [120, 30, 20],
        [255, 130, 110],
        [150, 100, 50],
        [240, 200, 120],
      ],
      "Loamy Soil": [
        [70, 40, 20],
        [210, 160, 110],
        [60, 60, 60],
        [170, 170, 170],
      ],
    };

    String baseSoilType =
        colorMap.entries
            .map((entry) {
              List<int> midpoint = [
                for (int i = 0; i < 3; i++)
                  (entry.value[0][i] + entry.value[1][i]) ~/ 2,
              ];
              double distance = sqrt(
                midpoint
                    .asMap()
                    .entries
                    .map((e) => pow(rgb[e.key] - e.value, 2))
                    .reduce((a, b) => a + b),
              );
              return MapEntry(entry.key, distance);
            })
            .reduce((a, b) => a.value < b.value ? a : b)
            .key;

    String combinedSoilType = baseSoilType;

    if (texture.toLowerCase() == 'smooth') {
      if (baseSoilType == "Sandy Soil") {
        combinedSoilType = "Sandy Clayey";
      } else if (baseSoilType == "Loamy Soil") {
        combinedSoilType = "Smooth Loamy";
      } else if (baseSoilType == "Clayey Soil") {
        combinedSoilType = "Smooth Clayey";
      }
    } else if (texture.toLowerCase() == 'rough') {
      if (baseSoilType == "Sandy Soil") {
        combinedSoilType = "Rough Sandy";
      } else if (baseSoilType == "Loamy Soil") {
        combinedSoilType = "Rough Loamy";
      } else if (baseSoilType == "Clayey Soil") {
        combinedSoilType = "Rough Clayey";
      }
    } else {
      if (baseSoilType == "Sandy Soil") {
        combinedSoilType = "Moderate Sandy";
      } else if (baseSoilType == "Loamy Soil") {
        combinedSoilType = "Moderate Loamy";
      } else if (baseSoilType == "Clayey Soil") {
        combinedSoilType = "Moderate Clayey";
      }
    }

    return combinedSoilType;
  }

  Map<String, double> matchSoilComposition(List<int> rgb, String texture) {
    Map<String, Map<String, double>> soilComposition = {
      "Clayey Soil": {"Sand": 10, "Silt": 30, "Clay": 60},
      "Sandy Soil": {"Sand": 90, "Silt": 5, "Clay": 5},
      "Loamy Soil": {"Sand": 40, "Silt": 40, "Clay": 20},
      "Sandy Clayey": {"Sand": 50, "Silt": 20, "Clay": 30},
      "Smooth Loamy": {"Sand": 35, "Silt": 50, "Clay": 15},
      "Rough Sandy": {"Sand": 80, "Silt": 10, "Clay": 10},
      "Rough Loamy": {"Sand": 45, "Silt": 45, "Clay": 10},
      "Moderate Sandy": {"Sand": 70, "Silt": 20, "Clay": 10},
      "Moderate Loamy": {"Sand": 50, "Silt": 40, "Clay": 10},
      "Moderate Clayey": {"Sand": 20, "Silt": 30, "Clay": 50},
    };

    String soilType = matchSoilType(rgb, texture);

    return soilComposition[soilType] ?? {"Sand": 0, "Silt": 0, "Clay": 0};
  }

  String determineTexture(Map<String, dynamic> textureFeatures) {
    double contrast = textureFeatures['contrast'];
    double homogeneity = textureFeatures['homogeneity'];

    if (contrast > 0.1 && homogeneity > 0.1) {
      return 'Smooth';
    } else if (contrast < 0.1 && homogeneity < 0.1) {
      return 'Rough';
    } else {
      return 'Moderate';
    }
  }

  bool isInRange(List<int> rgb, List<int> range, {int tolerance = 15}) {
    return (rgb[0] >= range[0] - tolerance && rgb[0] <= range[1] + tolerance) &&
        (rgb[1] >= range[2] - tolerance && rgb[1] <= range[3] + tolerance) &&
        (rgb[2] >= range[4] - tolerance && rgb[2] <= range[5] + tolerance);
  }

  Future<Map<String, dynamic>> classifySoil(
    String imagePath,
    void Function(String) onProgress,
  ) async {
    onProgress("📸 Extracting dominant color...");
    var dominantColor = await getDominantColor(imagePath);

    onProgress("🎨 Identifying soil color...");
    var soilColor = matchSoilColor(dominantColor);

    onProgress("🧪 Analyzing texture features...");
    var textureFeatures = await getTextureFeatures(imagePath);

    var moistureLevel = determineMoistureLevel(dominantColor);
    var texture = determineTexture(textureFeatures);

    onProgress("🔬 Determining soil composition...");
    var composition = matchSoilComposition(dominantColor, texture);

    onProgress("🔬 Classifying soil type...");
    var soilType = matchSoilType(dominantColor, texture);
    var density = soilType == "Clayey Soil" ? "1.6 g/cm³" : "1.3 g/cm³";
    var erosionVulnerability = soilType == "Sandy Soil" ? "High" : "Moderate";

    onProgress("✅ Soil classification complete!");
    return {
      'soilType': soilType,
      'composition': composition,
      'soilColor': soilColor,
      'texture': texture,
      'moistureLevel': moistureLevel,
      'density': density,
      'erosionVulnerability': erosionVulnerability,
      'contrast': textureFeatures['contrast'],
      'homogeneity': textureFeatures['homogeneity'],
    };
  }
}
