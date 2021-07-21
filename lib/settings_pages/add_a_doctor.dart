import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'settings_constants.dart';
import 'settings_card.dart';

class AddDoctors extends StatefulWidget {
  const AddDoctors({Key? key}) : super(key: key);
  @override
  _AddDoctorsState createState() => _AddDoctorsState();
}

class _AddDoctorsState extends State<AddDoctors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFB2EBF2),
        appBar: AppBar(
          title: Text(
            'Add A Doctor',
            style: kAppBarLabelStyle,
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF00BCD4),
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Please enter your physician\'s information below to add them to your list of doctors',
                    textAlign: TextAlign.center,
                    style: kLabelStyle.copyWith(color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextFormField(
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'First Name'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top:20.0, bottom: 20.0),
                child: TextFormField(
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Last Name'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextFormField(
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: 'Email Address'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
                child: TextFormField(
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Doctor\'s Numerical Code'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      child: Text(
                        'What is this?',
                        style: TextStyle(color: Colors.grey[800], fontSize: 17),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Alert3(),
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: 20.0, top: 5.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextFormField(
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Doctor\'s Label'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      child: Text(
                        'What is this?',
                        style: TextStyle(color: Colors.grey[800], fontSize: 17),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Alert4(),
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: 20.0, top: 5.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(
                      () {
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: Text(
                    'Add This Doctor',
                    style: kLabelStyle,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20.0),
                    primary: Colors.green[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
