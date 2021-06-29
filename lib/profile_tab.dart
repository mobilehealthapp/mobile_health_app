import 'package:flutter/material.dart';
import 'settings.dart';
import 'settings_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_edit.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
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
                  'First and Last name',
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
              editAnswer: 'Age',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: 'Sex',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: 'Date of birth',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: 'My medical conditions',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: 'My medications',
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEdit(),
                      ),
                    );
                  },
                );
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
