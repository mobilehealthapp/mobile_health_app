import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

const Color kActiveColour = Colors.lightGreen;
const Color kActiveBorderColour = Colors.lightGreenAccent;
const Color kInactiveColour = Colors.blueGrey;
const Color kInactiveBorderColour = Colors.transparent;

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
