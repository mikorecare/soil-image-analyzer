import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soil_image_recognizer/about.dart';
import 'package:soil_image_recognizer/documentation.dart';
import 'package:soil_image_recognizer/image_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soil Recognizer App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(camera: camera),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final CameraDescription camera;
  const MyHomePage({super.key, required this.camera});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  File? selectedImage;

  void _showAboutScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AboutWidget()),
    );
  }

  void _showDeocumentationScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DocumentationWidget()),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();

      final savedPath = await saveImageToFile(
        File(image.path).readAsBytesSync(),
      );

      setState(() {
        selectedImage = File(savedPath);
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> saveImageToFile(Uint8List imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(filePath);

    await file.writeAsBytes(imageBytes);
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Soil Recognizer App"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.book_outlined,
              size: 28,
              color: Colors.white,
            ),
            onPressed: () => _showDeocumentationScreen(context),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, size: 28, color: Colors.white),
            onPressed: () => _showAboutScreen(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(20.0)),

          Expanded(
            flex: 1,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: ClipRect(
                        child: OverflowBox(
                          alignment: Alignment.center,
                          minWidth: _controller!.value.previewSize!.height,
                          minHeight: _controller!.value.previewSize!.height,
                          maxWidth: _controller!.value.previewSize!.height,
                          maxHeight: _controller!.value.previewSize!.height,
                          child: CameraPreview(_controller!),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: takePicture,
                child: const Text("Take Picture"),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Upload Picture"),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (selectedImage != null)
                    ImageContainer(
                      imagePath: selectedImage!.path,
                      description: "Captured/Uploaded Soil Image",
                    )
                  else
                    const Center(child: Text("No image available")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
