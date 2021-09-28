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
import 'input_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_health_app/constants.dart';

Data ocrData = Data(null, null, null);

// Get the windowSize of the device (this is used for x and y coordinate translation)
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
  bool camera = true;
  bool isBusy = false;
  String pathToImage = '';
  List<InputImage> lastImage = [];
  bool isStreamingImages = false;
  RecognisedText? ocrText;
  Size? imageSize;
  InputImageRotation imageRotation = InputImageRotation.Rotation_0deg;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool initCamera = cameras.isNotEmpty;

  // Constant for a container that appears if the cameras have not
  // been initialized
  Container uninitializedCamera = Container(
    color: Colors.black,
    constraints: BoxConstraints.expand(),
    child: Center(
      child: Text(
        "The camera cannot be accessed. \n\nPlease ensure that camera access permissions have been enabled in the settings.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.white,
        ),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    if (initCamera) {
      // if the camera has been initialized, it starts a camera stream
      controller = CameraController(cameras[0], ResolutionPreset.high);
      controller.initialize().then((_) {
        controller.startImageStream(_processCameraImage);
        isStreamingImages = true;
        if (!mounted) {
          return;
        }
        setState(() {});
      });
      _initializeControllerFuture = controller.initialize();
    }
  }

  @override
  void dispose() {
    if (initCamera) {
      controller.dispose();
      textDetector.close();
      imageCache!.clear(); // clears cache
    }
    ocrData = Data(null, null, null);
    selected = [];
    super.dispose();
  }

  // Function that opens the image picker
  Future<void> _imgFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    while (image == null) {
      await Future.delayed(const Duration(milliseconds: 500), () {});
    }

    setState(() {
      _image = File(image.path);
      camera = false;
    });
    final inputImage = InputImage.fromFilePath(image.path);
    lastImage = [inputImage];
  }

  // Function that processes an InputImage (typically called after an image
  // has been taken (from _processCameraImage) or selected (from _imgFromGallery)
  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;

    final recognisedText = await textDetector.processImage(inputImage);

    ocrText = recognisedText;

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      imageSize = inputImage.inputImageData!.size;
      imageRotation = inputImage.inputImageData!.imageRotation;
    }
    isBusy = false;
  }

  // Function that processes CameraImages taken from the camera image stream
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

    // sets lastImage to be the most recent image in the stream
    lastImage = [inputImage];
  }

  // Function for the bottomNavigationBar
  Future<void> _onItemTapped(int index) async {
    _selectedIndex = index;
    switch (_selectedIndex) {
      case 0: // option labelled "Retake"
        try {
          await _initializeControllerFuture;
          // turn on image stream & stop displaying the recent image
          if (!isStreamingImages) {
            await controller.startImageStream(_processCameraImage);
            setState(() {
              showImage = false;
            });
            File(pathToImage).delete();
            isStreamingImages = true;
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
        break;
      case 1: // option labelled "Scan" or "Submit" (middle option)
        try {
          await _initializeControllerFuture;
          // Scan feature.
          // If the camera is streaming: take a picture, process it, then display it
          if (isStreamingImages) {
            await controller.stopImageStream(); // stop image stream
            final image = await controller.takePicture(); // take a picture
            if (lastImage != []) {
              await processImage(lastImage[0]); // process image
            }
            pathToImage = image.path; // set path to display image
            setState(() {
              showImage = true; // display image
              camera = true;
            });
            isStreamingImages = false;
          } else {
            // Submit feature
            // Creates the Data class object labelled ocrData containing the ocr data
            // Note that selected is a list of the selected data (see OCR_text_overlay.dart)
            if (dataType == "Blood Glucose") {
              ocrData = Data(dataType, (selected.isEmpty) ? null : selected[0],
                  glucoseUnit);
            } else {
              ocrData = Data(dataType, selected[0],
                  (selected.length == 2) ? selected[1] : null);
            }

            // Alert once they hit submit
            // Once the user taps on submit, the alert varies based on
            // the ocrData and inputtedData
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  String alertText = ocrData.ocrAlertText();
                  // nothing was selected
                  if (selected.isEmpty) {
                    return AlertDialog(
                        title: Text('Selected value(s)'),
                        content: Text('Please select a measurement'),
                        actions: [
                          TextButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ]);
                  }
                  // invalid ocrData
                  else if (!ocrData.isValid) {
                    return AlertDialog(
                      title: Text('Selected value(s)'),
                      content: Text(alertText),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
                  // ocrData does not match inputtedData
                  else if (!ocrData.isSame(inputtedData)) {
                    return AlertDialog(
                      title: Text('Selected value(s)'),
                      content: Text(
                          'The recorded value(s) from the image does not match the value(s) you entered. If you choose to submit anyways, the value(s) obtained from the image will be uploaded for your physician, the image will be saved for your physician to view, and the data point will be flagged in case the text detection was incorrect. \nWould you like to submit anyways?'),
                      actions: [
                        TextButton(
                          child: Text('No, retake the image'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('Yes, submit anyways'),
                          onPressed: () {
                            ocrData.processData();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            inputtedData = Data(null, null, null);
                            ocrData.recalculateAverage();
                            File(pathToImage).delete();
                          },
                        )
                      ],
                    );
                  }
                  // ocrData is valid and matches inputtedData
                  else {
                    return AlertDialog(
                      title: Text('Selected value(s)'),
                      content: Text(ocrData.ocrAlertText()),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('Yes, submit this measurement'),
                          onPressed: () {
                            ocrData.processData();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            inputtedData = Data(null, null, null);
                            ocrData.recalculateAverage();
                            File(pathToImage).delete();
                          },
                        )
                      ],
                    );
                  }
                });
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
        break;
      case 2: // Option labelled "From photos"
        // TODO: Fix image picker. The text detection and OCR overlay are not currently working
        try {
          if (initCamera) {
            await _initializeControllerFuture;
            if (isStreamingImages) {
              await controller.stopImageStream();
            }
          }
          await _imgFromGallery();
          if (lastImage.isNotEmpty) {
            await processImage(lastImage[0]);
          }
          setState(() {
            isStreamingImages = false;
            showImage = true;
            camera = false;
          });
        } catch (e) {
          print(e);
        }
        break;
    }
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take an image'),
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
            label: 'From Photos',
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
                  Image.file(camera ? File(pathToImage) : _image!),
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
            : (initCamera ? CameraPreview(controller) : uninitializedCamera),
      ),
      extendBody: true,
    );
  }
}
