import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_health_app/Camera/input_constants.dart';

final kTextFieldDecoration = InputDecoration(
  // used for text fields to keep theme consistent
  hintText: 'Enter a Value',
  hintStyle: GoogleFonts.rubik(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
    ),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColour, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColour, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

final kLabelStyle = GoogleFonts.rubik(
  // used on labels such as those on settings cards
  textStyle: TextStyle(
    fontSize: 20.0,
    color: Colors.white,
  ),
);

final kRedButtonStyle = ElevatedButton.styleFrom(
  // used on delete my data/account buttons
  primary: Colors.red[900],
  padding: EdgeInsets.all(10.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
);

final kSettingsCardStyle = ElevatedButton.styleFrom(
  // style of settings cards (buttons) that take user to another page upon being pressed
  primary: Color(0xFF607D8B),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
);

final kCancel = ElevatedButton.styleFrom(
  // style of cancel buttons
  primary: Colors.red[900],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  fixedSize: Size.fromHeight(40.0),
);
final kConfirm = ElevatedButton.styleFrom(
  // style of confirm buttons
  primary: Colors.green[400],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  fixedSize: Size.fromHeight(40.0),
);

final kTextStyle1 =
    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black);

final kTextStyle2 =
TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color: Colors.black);

Widget textFieldLabel(label) {
  // label that appears above text fields
  return Text(
    label,
    style: kTextStyle1,
  );
}

final kAlertTextStyle = TextStyle(
  /*
 used as the text style for the actions on alerts (the 'confirm', 'okay',
 'cancel', etc. buttons at the bottom)
  */
  fontSize: 16.0,
  color: kPrimaryColour,
);
