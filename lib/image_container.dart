import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soil_image_recognizer/service/SoilClassificationService.dart';

class ImageContainer extends StatefulWidget {
  final String imagePath;
  final String description;

  const ImageContainer({
    super.key,
    required this.imagePath,
    required this.description,
  });

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  final SoilClassificationService _soilService = SoilClassificationService();
  Map<String, dynamic>? soilData;
  bool isLoading = true;
  String progressMessage = "📡 Determining soil data...";

  @override
  void initState() {
    super.initState();
    print("🟢 initState: Classifying soil for ${widget.imagePath}");
    _classifySoil();
  }

  @override
  void didUpdateWidget(covariant ImageContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      print("🔄 didUpdateWidget: New image detected, reclassifying...");
      _classifySoil();
    }
  }

  Future<void> _classifySoil() async {
    print("🟢 _classifySoil() called for: ${widget.imagePath}");
    setState(() {
      isLoading = true;
      progressMessage = "📡 Determining soil data...";
    });

    try {
      var result = await _soilService.classifySoil(widget.imagePath, (message) {
        print("📢 Progress: $message");
        setState(() {
          progressMessage = message;
        });
      });

      result.forEach((key, value) {
        if (value is num && (value.isNaN || value.isInfinite)) {
          print("⚠️ Invalid value detected for $key: $value");
          result[key] = "N/A";
        }
      });

      setState(() {
        soilData = result;
        isLoading = false;
      });

      print("✅ Classification Complete!");
    } catch (e) {
      print("❌ Error classifying soil: $e");
      setState(() {
        isLoading = false;
        progressMessage = "⚠️ Failed to classify soil.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                isLoading
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text(
                          progressMessage,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                    : soilData == null
                    ? Text("⚠️ Unable to classify soil.")
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🟢 Soil Type: ${soilData!['soilType'] ?? 'Unknown'}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "🎨 Soil Color: ${soilData!['soilColor'] ?? 'N/A'}",
                        ),
                        Text(
                          "🔹 Composition: ${soilData!['composition'] ?? 'N/A'}",
                        ),
                        Text(
                          "💧 Moisture Level: ${soilData!['moistureLevel'] ?? 'N/A'}",
                        ),
                        Text("⚖ Density: ${soilData!['density'] ?? 'N/A'}"),
                        Text(
                          "🌪 Erosion Risk: ${soilData!['erosionVulnerability'] ?? 'N/A'}",
                        ),
                        Text("🧪 Texture: ${soilData!['texture'] ?? 'N/A'}"),
                        Text("🔬 Contrast: ${soilData!['contrast'] ?? 'N/A'}"),
                        Text(
                          "🔬 Homogeneity: ${soilData!['homogeneity'] ?? 'N/A'}",
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}

void showImageOverlay(
  BuildContext context,
  String imagePath,
  String description,
) {
  if (!File(imagePath).existsSync()) {
    print('❌ Image path does not exist: $imagePath');
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          print("🆕 Showing modal for: $imagePath");
          return ImageContainer(
            key: ValueKey(imagePath),
            imagePath: imagePath,
            description: description,
          );
        },
      );
    },
  );
}
