import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_health_app/settings_pages/settings_card.dart';

class ContactInfo extends StatefulWidget {
  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB2EBF2),
      appBar: AppBar(
        title: Text(
          'My Contact Information',
          style: GoogleFonts.rubik(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00BCD4),
      ),
      // body: Column(
      //   children: <Widget>[
      //     Expanded(
      //       child: ProfileTab(
      //         editAnswer: 'Telephone Number',
      //       ),
      //     ),
      //     Row(
      //       children: <Widget>[
      //         Expanded(
      //           child: ContactTab(answer: 'number input'),
      //         ),
      //       ],
      //     ),
      //     Expanded(
      //       child: ProfileTab(
      //         editAnswer: 'Email Address',
      //       ),
      //     ),
      //     Row(
      //       children: <Widget>[
      //         Expanded(
      //           child: ContactTab(answer: 'email'),
      //         ),
      //         Expanded(
      //           Container(
      //             padding: EdgeInsets.all(20.0),
      //             child: TextField(
      //                 style: TextStyle(
      //                   color: Colors.black,
      //                 ),
      //                 decoration: BoxDecoration(
      //                   color:
      //                 ),
      //                 onChanged: (value) {
      //                   cityName = value;
      //                 }),
      //           ),
      //           FlatButton(
      //             onPressed: () {
      //               Navigator.pop(context, cityName);
      //             },
      //             child: Text(
      //               'Get Weather',
      //               style: kButtonTextStyle,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //     Expanded(
      //       child: ProfileTab(
      //         editAnswer: 'address',
      //       ),
      //     ),
      //     Row(
      //       children: <Widget>[
      //         Expanded(
      //           child: ContactTab(answer: 'number input'),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
