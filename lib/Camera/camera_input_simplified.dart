import 'package:flutter/material.dart';

import 'dart:async';


import 'package:mobile_health_app/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';

import 'dart:ui';

import 'package:image_picker/image_picker.dart';
import 'package:mobile_health_app/constants.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    //Perhaps this should only be run if the cameras are used?
    //But then again, I have no idea how much of a performance hit init-ing
    //a list is.
    cameras = await availableCameras();
  } catch (e) {
    cameras = [];
    print(e);
  }
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageSelection(),
    );
  }
}

class ImageSelection extends StatefulWidget {
  @override
  _ImageSelectionState createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
  //index for managing current page
  int selectedIndex = 0;

  /////////Bottom navigation bar functions/////////

  List<BottomNavigationBarItem> buildBottomNavBar() {
    //Returns a list of all items meant to go in the bottom nav bar.
    //Implemented separately for readability.
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.camera_alt_outlined),
        label: 'Camera',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.crop_square),
        label: 'From Photos',
      ),
    ];
  }

  void bottomTapped(int index) {
    //Define onTap behaviour.
    //i.e. when navbar is touched, switch pages and update index.
    setState(() {
      selectedIndex = index;
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  /////////Page navigator functions/////////

  void pageChanged(int index) {
    //Defines behaviour for page changing
    // (should only be used if swiping between pages is allowed)
    setState(() {
      selectedIndex = index;
    });
  }

  PageController pageController = PageController(
    //Defines PageView behaviours
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        //^^ (Un/)comment for scrolling between pages
        onPageChanged: (index) {
          pageChanged(index);
        },
        //Pages are placed in this list below vv
        children: <Widget>[
          CameraScreen(),
          GalleryScreen(),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select an image'),
        ),
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: kPrimaryColour,
            items: buildBottomNavBar(),
            currentIndex: selectedIndex,
            onTap: (index) {
              bottomTapped(index);
            }),
        body: ConstrainedBox(
          constraints:
          BoxConstraints.loose(Size(double.infinity, double.infinity)),
          child: buildPageView(),
        ));
  }
}

class CameraScreen extends StatefulWidget {
  //Screen shows camera stream and allows user to take picture.
  //After picture is taken, pushes to image display/OCR data selection.

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  //Future is used to be able to tell when controller has been init'd,
  //as it takes a moment to load.

  @override
  void initState() {
    super.initState();
    //cameras is the list of all camera on the device given to us from main.dart
    //I would personally init that list here instead
    //cameras[0] **SHOULD** be the rear camera on all devices
    //(it's first as it should be the best one.)
    //That said, the whole multi-camera thing they're doing these days
    //could interfere with this. Honestly no idea.
    controller = CameraController(cameras[0], ResolutionPreset.max);
    _initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    imageCache!.clear(); // clears cache
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Camera stream display
      body: FutureBuilder<void>(
        //A future builder is essentially just "until the future is an actual
        //thing, do this", in this case until controller is init'd,
        //show a loading circle.
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              //TODO: Possibly add more error handling here?
              // i.e, if it's done but failed? ect.
              return Container(
                child: CameraPreview(controller),
                height: double.infinity,
                width: double.infinity,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),

      //"take picture" button.
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await controller.takePicture();

              //If a picture is taken, push to DisplayPicture
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DisplayPicture(
                    imagePath: image.path,
                  )));
            } catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.camera)),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late XFile image;
  String errorMessage = '';
  final ImagePicker _picker = ImagePicker();

  void getImage() async {
    //Opens the phones gallery (because gallery UI is hard)
    //so user can choose a photo

    XFile? tempImage = await _picker.pickImage(source: ImageSource.gallery);

    //TODO: Error handling for image selection.

    if (tempImage == null) {

      print(NullThrownError());

    } else {

      image = tempImage;
      //If a picture is chosen, push to DisplayPicture
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DisplayPicture(
            imagePath: image.path,
          )));
    }
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  Widget relaunchGallery() {
    return const Scaffold();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: [
              Text('Relauch Gallery?'),
              IconButton(
                  icon: const Icon(Icons.crop_square),
                  onPressed: () {
                    getImage();
                  })
            ])));
  }
}

class DisplayPicture extends StatelessWidget {
  final String imagePath;

  const DisplayPicture({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
