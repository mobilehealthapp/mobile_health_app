import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:async';

// final inputImage = InputImage.fromFile(file);
//
// final textDetector = GoogleMlKit.vision.textDetector();
// final RecognisedText recognisedText = await textDetector.processImage(inputImage);
//
// String text = recognisedText.text;
// for (TextBlock block in recognisedText.blocks) {
// final Rect rect = block.rect;
// final List<Offset> cornerPoints = block.cornerPoints;
// final String text = block.text;
// final List<String> languages = block.recognizedLanguages;
//
// for (TextLine line in block.lines) {
// // Same getters as TextBlock
// for (TextElement element in line.elements) {
// // Same getters as TextBlock
// }
// }
// }
//
//
// textDetector.close();
