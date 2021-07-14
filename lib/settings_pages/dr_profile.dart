import 'package:flutter/material.dart';
import 'package:mobile_health_app/settings_pages/dr_profileEdit.dart';
import 'package:mobile_health_app/settings_pages/settings_constants.dart';
import 'settings_card.dart';

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
      body: ListView(
        children: <Widget>[
          ProfileTab(
            editAnswer: '${DrProfileEdit.drFirst} ${DrProfileEdit.drLast}',
          ),
          ProfileTab(
            editAnswer: '${DrProfileEdit.quali}',
          ),
          ProfileTab(
            editAnswer: '${DrProfileEdit.drTele}',
          ),
          ProfileTab(
            editAnswer: '${DrProfileEdit.drEmail}',
          ),
          ProfileTab(
            editAnswer: '${DrProfileEdit.drFax}',
          ),
          ProfileTab(
            editAnswer: '${DrProfileEdit.clinicAdd}',
          ),
          GestureDetector(
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
        ],
      ),
    );
  }
}
