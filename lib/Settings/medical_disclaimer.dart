import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:flutter/services.dart' show rootBundle;

class MedicalDisclaimer extends StatefulWidget {
  const MedicalDisclaimer({Key? key}) : super(key: key);

  @override
  _MedicalDisclaimerState createState() => _MedicalDisclaimerState();
}

class _MedicalDisclaimerState extends State<MedicalDisclaimer> {

  String data = '';
  fetchFileData() async{
    String responseText;
    responseText= await rootBundle.loadString('assets/medical_disclaimer2021.txt');

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
        title: Text('Medical Disclaimer'),
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
