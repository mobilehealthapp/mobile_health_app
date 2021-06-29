import 'main.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Take an image'),
          backgroundColor: Colors.cyan,
        ),
        body: CameraPreview(controller),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.arrow_back_ios), label: 'back'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_overscan),
              label: 'Scan',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.crop_square), label: 'from photos')
          ],
        ),
        extendBody: true,
      ),
    );
  }
}