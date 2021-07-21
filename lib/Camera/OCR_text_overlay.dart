import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

double translateX(
    double x, InputImageRotation rotation, Size size, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.Rotation_90deg:
      return x *
          size.width /
          (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    case InputImageRotation.Rotation_270deg:
      return size.width -
          x *
              size.width /
              (Platform.isIOS
                  ? absoluteImageSize.width
                  : absoluteImageSize.height);
    default:
      return x * size.width / absoluteImageSize.width;
  }
}

double translateY(
    double y, InputImageRotation rotation, Size size, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.Rotation_90deg:
      return y *
          size.height /
          (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    case InputImageRotation.Rotation_270deg:
      return y *
          size.height /
          (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    default:
      return y * size.height / absoluteImageSize.height;
  }
}

Stack? CameraOverlay(recognisedText, absoluteImageSize, rotation, size) {
  Color _blockColour = Colors.blueGrey.withOpacity(0.75);
  print(size);
  List<Widget> boxes = [
    // Positioned.fromRect(
    //   rect: Rect.fromLTRB(0, 0, 414, 56),
    //   child: Container(
    //       width: 10,
    //       height: 10,
    //       decoration: BoxDecoration(
    //         color: Colors.blueGrey.withOpacity(1),
    //       )),
    // ),
  ];
  for (TextBlock block in recognisedText!.blocks) {
    for (TextLine line in block.lines) {
      for (TextElement element in line.elements) {
        if (element.text.contains(RegExp(r'.*[0-9]+.*'))) {
          final left =
              translateX(element.rect.left, rotation, size, absoluteImageSize);
          final right =
              translateX(element.rect.right, rotation, size, absoluteImageSize);
          final top =
              translateY(element.rect.top, rotation, size, absoluteImageSize);
          final bottom = translateY(
              element.rect.bottom, rotation, size, absoluteImageSize);
          boxes.add(
            Positioned.fromRect(
              rect: Rect.fromLTRB(left, top, right, bottom),
              child: FittedBox(
                fit: BoxFit.contain,
                child: GestureDetector(
                  onTap: () {
                    print("tapped on ${element.text}!");
                  },
                  child: Container(
                    color: _blockColour,
                    child: Text(
                      element.text,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }
    }
  }
  return Stack(
    clipBehavior: Clip.none,
    fit: StackFit.loose,
    children: boxes,
  );
}
