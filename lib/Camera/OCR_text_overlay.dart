import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:bordered_text/bordered_text.dart';
import 'data_input_page.dart';
import 'input_constants.dart';
import 'overlay_constants.dart';

List<String> selected = [];

class CameraOverlay extends StatefulWidget {
  final RecognisedText? recognisedText;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final Size size;

  const CameraOverlay(
      this.recognisedText, this.absoluteImageSize, this.rotation, this.size);

  @override
  _CameraOverlayState createState() => _CameraOverlayState(
      this.recognisedText, this.absoluteImageSize, this.rotation, this.size);
}

class _CameraOverlayState extends State<CameraOverlay> {
  final RecognisedText? recognisedText;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final Size size;
  List<Color> _blockColours = [];
  List<Color> _borderColours = [];
  List<String> text = [];
  int numOfMeasurements =
      kNumberOfVariables[dataTypes.indexOf(dataType) - 1][1];

  _CameraOverlayState(
      this.recognisedText, this.absoluteImageSize, this.rotation, this.size);

  // activateOverlay changes the colour of a box from inactive to active
  void activateOverlay(selectedText) {
    setState(() {
      _blockColours[text.indexOf(selectedText)] =
          kActiveColour.withOpacity(0.75);
      _borderColours[text.indexOf(selectedText)] = kActiveBorderColour;
    });
  }

  // deactivateOverlay changes the colour of a box from active to inactive
  void deactivateOverlay(selectedText) {
    setState(() {
      _blockColours[text.indexOf(selectedText)] =
          kInactiveColour.withOpacity(0.75);
      _borderColours[text.indexOf(selectedText)] = kInactiveBorderColour;
    });
  }

  // getBoxes returns the list of boxes that contain the numeric text for the
  // OCR output. These boxes are Stacked on top of the image preview
  List<Widget> getBoxes() {
    int count = 0;
    List<Widget> boxes = [];
    for (TextBlock block in recognisedText!.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          // filter out non numeric detected text
          if (element.text.contains(RegExp(r'.*[0-9]+.*'))) {
            // Lists of block colours and border colours to make it easier
            // to change the colour of a specific box
            _blockColours.add(Colors.blueGrey.withOpacity(0.75));
            _borderColours.add(Colors.transparent);

            text.add(element.text);

            // Coordinates of the box (must be translated properly first)
            final left = translateX(
                element.rect.left, rotation, size, absoluteImageSize);
            final right = translateX(
                element.rect.right, rotation, size, absoluteImageSize);
            final top =
                translateY(element.rect.top, rotation, size, absoluteImageSize);
            final bottom = translateY(
                element.rect.bottom, rotation, size, absoluteImageSize);

            // Add the box to the list of boxes
            boxes.add(
              Positioned.fromRect(
                rect: Rect.fromLTRB(left, top, right, bottom),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: GestureDetector(
                    // when the box is tapped on, if it was already selected
                    // the colour changes from green to grey and vice versa if
                    // it wasn't selected
                    // this also deselects the least recently tapped on box if
                    // the user tries to select more boxes than the number of
                    // measurements
                    onTap: () {
                      setState(() {
                        if (_blockColours[text.indexOf(element.text)] ==
                            kActiveColour.withOpacity(0.75)) {
                          deactivateOverlay(element.text);
                          selected.remove(element.text);
                        } else {
                          activateOverlay(element.text);
                          if (selected.length == numOfMeasurements) {
                            String toRemove = selected[0];
                            deactivateOverlay(toRemove);
                            selected.remove(toRemove);
                          }
                          selected.add(element.text);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: _borderColours[count]),
                        color: _blockColours[count],
                      ),
                      child: BorderedText(
                        strokeWidth: 1.5,
                        strokeColor: Colors.black54,
                        child: Text(
                          element.text,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            count += 1;
          }
        }
      }
    }
    return boxes;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.loose,
      children: getBoxes(),
    );
  }

  @override
  void initState() {
    text = [];
    _borderColours = [];
    _blockColours = [];
    numOfMeasurements = kNumberOfVariables[dataTypes.indexOf(dataType) - 1][1];
    super.initState();
  }
}
