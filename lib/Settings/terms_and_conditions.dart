import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {

  String data = '';
  fetchFileData() async{
    String responseText;
    responseText= await rootBundle.loadString('assets/terms_and_conds2021.txt');

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
        title: Text('Terms and Conditions'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(32),
        children: [
          Text(data),],
      ),
    );
  }
}
