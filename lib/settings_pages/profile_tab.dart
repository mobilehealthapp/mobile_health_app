import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/contact_info.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
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
                  '${ProfileEdit.first} ${ProfileEdit.last}',
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
              editAnswer: '${ProfileEdit.age}',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: '${ProfileEdit.dob}',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: '${ProfileEdit.sexChoose}',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: '${ProfileEdit.ht}',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: '${ProfileEdit.wt}',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: '${ProfileEdit.conds}',
            ),
          ),
          Expanded(
            child: ProfileTab(
              editAnswer: '${ProfileEdit.meds}',
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactInfo(),
                    ),
                  );
                });
              },
              child: SettingsCard(
                settingsTab: TabContent(label: 'My Contact Information'),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEdit(),
                  ),
                ).then(
                  (value) => ProfileEdit.updateProfile(),
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

// void awaitDataReturn(BuildContext context) async {
//   final result = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => SecondScreen(),),
//   );
//   setState(() {
//     text = result;
//   },);
// }
