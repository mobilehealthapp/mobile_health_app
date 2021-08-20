import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// This file is used for universal constants that are used throughout
// the app

//////// TEXT STYLES ////////

// Used for the Physician home page for patient cards
const kTextLabel1 = TextStyle(
  // used to say 'hello, [name]' on home page
  fontSize: 30.0,
  fontWeight: FontWeight.w400,
);

// Used for the graphs
const kTextLabel2 = TextStyle(
  // used in multiple places to give simple style to text
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
);

// AppBar text style
final kAppBarLabelStyle = GoogleFonts.rubik(
  // style of app bar labels
  textStyle: TextStyle(
    color: Colors.white,
    fontSize: 25.0,
  ),
);

const kGraphTitleTextStyle = TextStyle(
  // used above graphs in health analysis and home page as title text style
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 17.0,
);

//////// COLOURS ////////

// Theme colours (these were obtained from the BC LTD logo)
const kPrimaryColour =
    Color(0xFF1B4DA8); // primary colour of app theme (app bars, accents, etc.)
const kSecondaryColour =
    Color(0xFFe6f3fc); // secondary colour of app theme (background colours)
