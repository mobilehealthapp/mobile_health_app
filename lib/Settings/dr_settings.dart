import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:mobile_health_app/Drawers/PhysDrawer.dart';
import 'delete_data_or_account.dart';
import 'settings_card.dart';
import 'settings_constants.dart';

class DrSettingsPage extends StatefulWidget {
  @override
  _DrSettingsPageState createState() => _DrSettingsPageState();
}

class _DrSettingsPageState extends State<DrSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PhysDrawers(),
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    Navigator.of(context)
                        .pushNamed('/drProfile'); // navigate to profile page
                  },
                );
              },
              child: TabContent(label: 'My Profile'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: TabContent(label: 'Province/Territory'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    Navigator.of(context).pushNamed(
                        '/privacyPolicy'); // navigate to privacy policy page
                  },
                );
              },
              child: TabContent(label: 'Privacy Policy'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    Navigator.of(context).pushNamed(
                        '/termsAndConditions'); // navigate to terms and conditions page
                  },
                );
              },
              child: TabContent(label: 'Terms and Conditions'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    Navigator.of(context).pushNamed(
                        '/medicalDisclaimer'); // navigate to medical disclaimer page
                  },
                );
              },
              child: TabContent(label: 'Medical Disclaimer'),
              style: kSettingsCardStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new Alert(
                      widget: AlertDoctorData(),
                      // navigates to alert where user can input credentials and delete data
                      alertBody:
                          'This will erase all of your data except for your email address and your account type.',
                    );
                  },
                );
              },
              child: TabContent2(label: 'Delete My Data'),
              style: kRedButtonStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new Alert(
                      widget: AlertDoctorAccount(),
                      // navigates to alert where user can input credentials and delete account
                      alertBody: 'This will completely delete your account.',
                    );
                  },
                );
              },
              child: TabContent2(label: 'Delete My Account'),
              style: kRedButtonStyle,
            ),
          ),
        ],
      ),
    );
  }
}

//Firestore.instance.collection('path').document('name').update({'Desc': FieldValue.delete()}).whenComplete((){
//   print('Field Deleted');
// });
