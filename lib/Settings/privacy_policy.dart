import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:flutter/services.dart' show rootBundle;


class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {

  String data = '';
  fetchFileData() async{
    String responseText;
    responseText= await rootBundle.loadString('assets/privacy_policy2021.txt');

    setState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
   fetchFileData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColour,
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(32),
          children: [
            Text(data),
          ],
      ),
    );
  }

}
