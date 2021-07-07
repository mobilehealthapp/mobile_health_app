import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a Value',
  hintStyle: GoogleFonts.rubik(
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
    ),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF0097A7), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF0097A7), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

final kLabelStyle = GoogleFonts.rubik(
  textStyle: TextStyle(
    fontSize: 20.0,
    color: Colors.white,
  ),
);

final kAppBarLabelStyle = GoogleFonts.rubik(
  textStyle: TextStyle(
    color: Colors.white,
    fontSize: 25.0,
  ),
);
