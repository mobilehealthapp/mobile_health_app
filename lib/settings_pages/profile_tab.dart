import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
import 'settings_card.dart';
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
      body: SizedBox(
        // height: 700.0,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            ProfileTab(
              editAnswer: '${ProfileEdit.first} ${ProfileEdit.last}',
            ),
            ProfileTab(
              editAnswer: '${ProfileEdit.age}',
            ),
            ProfileTab(
              editAnswer: '${ProfileEdit.dob}',
            ),
            ProfileTab(
              editAnswer: '${ProfileEdit.sexChoose}',
            ),
            ProfileTab(
              editAnswer: '${ProfileEdit.ht}',
            ),
            ProfileTab(
              editAnswer: '${ProfileEdit.wt}',
            ),
            ProfileTab(
              editAnswer: '${ProfileEdit.conds}',
            ),
            ProfileTab(
              editAnswer: '${ProfileEdit.meds}',
            ),
            ProfileTab(
              editAnswer: '${ProfileEdit.tele}',
            ),
            ProfileTab(
              editAnswer: '${ProfileEdit.email}',
            ),
            ProfileTab(
              editAnswer: '${ProfileEdit.adr}',
            ),
            GestureDetector(
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
          ],
        ),
      ),
    );
  }
}
