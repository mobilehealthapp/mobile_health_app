import 'dart:async';
import 'package:mobile_health_app/Camera/data_input_page.dart';
import 'data_transfer.dart';
import 'package:mobile_health_app/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'OCR_text_overlay.dart';
import 'dart:ui';

final windowSize =
    Size(window.physicalSize.width / 2, window.physicalSize.height / 2);

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
  List<InputImage> lastImage = [];
  bool isStreamingImages = false;
  String alertText = 'Nothing Found!';
  RecognisedText? ocrText;
  Size? imageSize;
  InputImageRotation imageRotation = InputImageRotation.Rotation_0deg;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      controller.startImageStream(_processCameraImage);
      isStreamingImages = true;
      if (!mounted) {
        return;
      }
      print("size = $windowSize");
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

    ocrText = recognisedText;
    alertText = recognisedText.text;
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      imageSize = inputImage.inputImageData!.size;
      imageRotation = inputImage.inputImageData!.imageRotation;
    }
    isBusy = false;
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[0];
    final imageRotation =
        InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.Rotation_0deg;

    final inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    lastImage = [inputImage];
    // processImage(inputImage);
  }

  Future<void> _onItemTapped(int index) async {
    _selectedIndex = index;
    switch (_selectedIndex) {
      case 0:
        try {
          await _initializeControllerFuture;
          if (!isStreamingImages) {
            await controller.startImageStream(_processCameraImage);
            setState(() {
              showImage = false;
            });
            isStreamingImages = true;
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
        break;
      case 1:
        try {
          await _initializeControllerFuture;
          if (isStreamingImages) {
            await controller.stopImageStream();
            final image = await controller.takePicture();
            if (lastImage != []) {
              await processImage(lastImage[0]);
            }
            pathToImage = image.path;
            setState(() {
              showImage = true;
            });
            isStreamingImages = false;
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('OCR output'),
                    content: Text(alertText),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Selected value(s)'),
                    content: selected.isEmpty
                        ? Text('Please select a measurement')
                        : Text(bpAlertText(dataType, selected[0],
                            (selected.length == 2) ? selected[1] : null)),
                    actions: [
                      TextButton(
                        child: Text(
                            isValid ? 'Yes, submit this measurement' : 'Ok'),
                        onPressed: () {
                          if (isValid) {
                            processData(dataType, selected[0],
                                (selected.length == 2) ? selected[1] : null);
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
                  );
                });
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
        break;
      case 2:
        break;
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
        backgroundColor: kPrimaryColour,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: kPrimaryColour,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Retake',
          ),
          BottomNavigationBarItem(
            icon: showImage ? Icon(Icons.check) : Icon(Icons.settings_overscan),
            label: showImage ? 'Submit' : 'Scan',
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
      body: ConstrainedBox(
        constraints:
            BoxConstraints.loose(Size(double.infinity, double.infinity)),
        child: showImage
            ? Stack(
                clipBehavior: Clip.none,
                fit: StackFit.loose,
                children: [
                  Image.file(File(pathToImage)),
                  Container(
                    child: CameraOverlay(
                      ocrText,
                      imageSize!,
                      imageRotation,
                      Size(
                          windowSize.width,
                          windowSize.height -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              kBottomNavigationBarHeight),
                    ),
                  ),
                ],
              )
            : CameraPreview(controller),
      ),
      extendBody: true,
    );
  }
}
