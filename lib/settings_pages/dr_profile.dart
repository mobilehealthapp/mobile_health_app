import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/dr_profileEdit.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
import 'settings_card.dart';
import 'package:google_fonts/google_fonts.dart';

class DrProfilePage extends StatefulWidget {
  @override
  _DrProfilePageState createState() => _DrProfilePageState();
}

class _DrProfilePageState extends State<DrProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB2EBF2),
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00BCD4),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xFF607D8B),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  '(Dr.) First and Last name',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: 'Qualifications',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: 'Telephone Number',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: 'Email Address',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: 'Fax',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: 'Clinic Address',
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DrProfileEdit(),
                    ),
                  );
                });
              },
              child: SettingsCard(
                settingsTab: TabContent(label: 'Edit my information'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// void awaitDataReturn(BuildContext context) async {
//   final result = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => SecondScreen(),),
//   );
//   setState(() {
//     text = result;
//   },);
// }
