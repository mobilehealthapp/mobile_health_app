import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

late List<CameraDescription> cameras;

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  final textDetector = GoogleMlKit.vision.textDetector();
  bool showImage = false;
  bool isBusy = false;
  String pathToImage = '';

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    _initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    textDetector.close();
    super.dispose();
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final recognisedText = await textDetector.processImage(inputImage);
    print('Found ${recognisedText.blocks.length} textBlocks');
    print(recognisedText.text);
    isBusy = false;
  }

  Future<void> _onItemTapped(int index) async {
    _selectedIndex = index;
    if (_selectedIndex == 0) {
      Navigator.pop(context);
    } else if (_selectedIndex == 1) {
      try {
        await _initializeControllerFuture;

        // Attempt to take a picture and then get the location
        // where the image file is saved.
        // final picker = ImagePicker();
        // final inputImage = await picker.getImage(source: ImageSource.camera);
        final image = await controller.takePicture();
        final inputImage = InputImage.fromFilePath(image.path);
        setState(() {
          if (showImage) {
            showImage = false;
          } else {
            showImage = true;
          }
        });
        // final RecognisedText recognisedText =
        //     await textDetector.processImage(inputImage);
        // debugPrint(recognisedText.text);
        pathToImage = image.path;
        await processImage(inputImage);
      } catch (e) {
        // If an error occurs, log the error to the console.
        print(e);
      }
    } else {
      print('from photos');
    }
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Take an image'),
        backgroundColor: Colors.cyan,
      ),
      body:
          showImage ? Image.file(File(pathToImage)) : CameraPreview(controller),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.cyan,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back_ios),
            label: 'back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_overscan),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.crop_square),
            label: 'from photos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
      extendBody: true,
    );
  }
}
