import 'package:flutter/material.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Developers:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Dela Cruz, Nhero Jeshua M.'),
            const Text('De Jesus, Lianne Ashley P.'),
            const Text('Flameño, Cyrus Yael B.'),
            const Text('Roque, Jared Joseph B.'),
            const Text('Simbol, Monique Mhay H.'),
            const SizedBox(height: 16),
            const Text(
              'Study Description:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This study aims to develop an image recognition-based soil analysis machine. '
              'The machine will assess key soil properties such as texture, moisture, nutrients, and contaminants. '
              'It focuses on providing faster, more accessible soil analysis compared to traditional methods, with its accuracy '
              'dependent on factors like image quality, lighting, and camera resolution. However, it only analyzes physical soil properties, '
              'not chemical ones, and is intended for prototyping rather than large-scale implementation.',
              style: TextStyle(fontSize: 16),
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
