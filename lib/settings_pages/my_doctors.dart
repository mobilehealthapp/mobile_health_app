import 'package:flutter/material.dart';
import 'settings_constants.dart';
import 'add_a_doctor.dart';
import 'settings_card.dart';

class MyDoctors extends StatefulWidget {
  @override
  _MyDoctorsState createState() => _MyDoctorsState();
}

class _MyDoctorsState extends State<MyDoctors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB2EBF2),
      appBar: AppBar(
        title: Text(
          'My Doctors',
          style: kAppBarLabelStyle,
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00BCD4),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDoctors(),
                      ),
                    );
                  },
                );
              },
              child: TabContent(label: 'Add a doctor'),
              style: kSettingsCardStyle,
            ),
          ),
          DoctorCard(),
        ],
      ),
    );
  }
}


class DoctorCard extends StatelessWidget { //Card which will display information of doctor once patient adds one
  const DoctorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(3.0),
            child: Text(
                'Doctor\'s Label',
                style: kLabelStyle,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding:  EdgeInsets.all(3.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'First and Last Name',
                    style: kLabelStyle,
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Qualifications',
                    style: kLabelStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding:  EdgeInsets.all(3.0),
            child: Text(
                'Email',
                style: kLabelStyle,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Color(0xFF607D8B),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}