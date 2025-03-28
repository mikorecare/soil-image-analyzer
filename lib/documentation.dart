import 'package:flutter/material.dart';

class DocumentationWidget extends StatelessWidget {
  const DocumentationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documentation')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Soil Texture Classification:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'The texture of the soil is determined based on contrast and homogeneity values. Below is a table that illustrates how the soil is classified based on these features:',
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Condition',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Contrast',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Homogeneity',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Texture',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: const [
                  DataRow(
                    cells: [
                      DataCell(Text('Smooth')),
                      DataCell(Text('> 0.1')),
                      DataCell(Text('> 0.1')),
                      DataCell(Text('Smooth')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Rough')),
                      DataCell(Text('< 0.1')),
                      DataCell(Text('< 0.1')),
                      DataCell(Text('Rough')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Moderate')),
                      DataCell(Text('< 0.1')),
                      DataCell(Text('> 0.1 or > 0.1')),
                      DataCell(Text('Moderate')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Soil Classification Table:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Soil Type',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Sand (%)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Silt (%)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Clay (%)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: const [
                  DataRow(
                    cells: [
                      DataCell(Text('Clayey Soil')),
                      DataCell(Text('10')),
                      DataCell(Text('30')),
                      DataCell(Text('60')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Sandy Soil')),
                      DataCell(Text('90')),
                      DataCell(Text('5')),
                      DataCell(Text('5')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Loamy Soil')),
                      DataCell(Text('40')),
                      DataCell(Text('40')),
                      DataCell(Text('20')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Sandy Clayey')),
                      DataCell(Text('50')),
                      DataCell(Text('20')),
                      DataCell(Text('30')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Smooth Loamy')),
                      DataCell(Text('35')),
                      DataCell(Text('50')),
                      DataCell(Text('15')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Rough Sandy')),
                      DataCell(Text('80')),
                      DataCell(Text('10')),
                      DataCell(Text('10')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Rough Loamy')),
                      DataCell(Text('45')),
                      DataCell(Text('45')),
                      DataCell(Text('10')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Moderate Sandy')),
                      DataCell(Text('70')),
                      DataCell(Text('20')),
                      DataCell(Text('10')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Moderate Loamy')),
                      DataCell(Text('50')),
                      DataCell(Text('40')),
                      DataCell(Text('10')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Moderate Clayey')),
                      DataCell(Text('20')),
                      DataCell(Text('30')),
                      DataCell(Text('50')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Soil Color Classification Table:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Color',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'RGB Range (Min)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'RGB Range (Max)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: const [
                  DataRow(
                    cells: [
                      DataCell(Text('Black')),
                      DataCell(Text('[0, 0, 0]')),
                      DataCell(Text('[85, 85, 85]')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('White/Pale/Bleached')),
                      DataCell(Text('[170, 150, 130]')),
                      DataCell(Text('[255, 255, 255]')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Red')),
                      DataCell(Text('[120, 30, 20]')),
                      DataCell(Text('[255, 130, 110]')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Yellow to Yellow-Brown')),
                      DataCell(Text('[150, 100, 50]')),
                      DataCell(Text('[240, 200, 120]')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Brown')),
                      DataCell(Text('[70, 40, 20]')),
                      DataCell(Text('[210, 160, 110]')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Grey/Green/Gleyed')),
                      DataCell(Text('[60, 60, 60]')),
                      DataCell(Text('[170, 170, 170]')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Image Processing Functions Table:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Function Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: const [
                  DataRow(
                    cells: [
                      DataCell(Text('rgbToHls')),
                      DataCell(
                        Text(
                          'Converts RGB color values to HLS (Hue, Lightness, Saturation) format.',
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('getTextureFeatures')),
                      DataCell(
                        Text(
                          'Extracts contrast and homogeneity from a grayscale image.',
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('getDominantColor')),
                      DataCell(
                        Text(
                          'Finds the dominant color of an image using pixel clustering.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Terms Used in Data Analysis:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(),
              children: const [
                TableRow(
                  children: [
                    Text('Soil Type'),
                    Text(
                      'The classification of soil based on its texture and composition.',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Composition'),
                    Text(
                      'The percentage of different components in the soil (sand, silt, clay).',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Soil Color'),
                    Text(
                      'The color of the soil, which indicates its mineral content and moisture level.',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Texture'),
                    Text(
                      'The physical feel of the soil, determined by sand, silt, and clay proportions.',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Moisture Level'),
                    Text('The amount of water present in the soil.'),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Density'),
                    Text('The mass of the soil per unit volume.'),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Erosion Vulnerability'),
                    Text(
                      'The likelihood of the soil eroding based on its texture and moisture content.',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Contrast'),
                    Text(
                      'A texture feature that measures the difference in intensity between adjacent pixels.',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Homogenity'),
                    Text(
                      'A texture feature that measures the uniformity of pixel intensities in an image.',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Soil Analysis Methodology:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'The soil analysis is performed using image recognition technology. The captured images of soil samples are processed to identify key characteristics such as texture, color, and composition. Here is how the analysis is made:'
              '\n\n1. Image Preprocessing: The captured images undergo preprocessing steps like noise reduction and contrast adjustment to enhance image quality.'
              '\n\n2. Texture Analysis: Texture features such as contrast and homogeneity are extracted from the grayscale version of the soil image to assess the texture. These values help determine the soil\'s physical properties like smoothness or roughness.'
              '\n\n   - **Contrast Formula:** \n     Contrast is calculated as the difference in pixel intensities between the maximum and minimum values in the image. \n     Formula: `Contrast = max(I) - min(I)` where `I` is the pixel intensity.'
              '\n\n   - **Homogeneity Formula:** \n     Homogeneity is a measure of how uniform the pixel intensities are within the image. It can be calculated using the following formula: \n     Formula: `Homogeneity = sum(sum(P(i,j) / (1 + |i - j|)))` where `P(i,j)` is the probability of the pixel pair (i, j).'
              '\n\n3. Color Classification: The color of the soil is analyzed by converting RGB values to HLS (Hue, Lightness, Saturation) format. This helps in identifying soil types based on their mineral content and moisture levels.'
              '\n\n4. Composition Estimation: Using image data, an estimation of the soil\'s sand, silt, and clay composition is made based on predefined color and texture patterns.'
              '\n\n5. Moisture Level and Contaminant Detection: Moisture levels are indirectly inferred from the soil texture and color, and contamination might be detected based on irregularities in the soil texture or abnormal color patterns.'
              '\n\nSimple computations are performed to classify the soil type and calculate texture features like contrast and homogeneity. For instance, contrast is computed as the difference in pixel intensities, and homogeneity measures the uniformity of pixel intensities within the image.',
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
