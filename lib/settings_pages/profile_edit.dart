import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileEdit extends StatefulWidget {
  static String? sexChoose = '--Sex--';
  static String first = 'First Name';
  static String last = 'Last Name';
  static String age = 'Age';
  static String dob = 'Date of Birth (DD-MM-YYYY)';
  static String meds = 'My Medications';
  static String conds = 'My Medical Conditions';
  static String wt = 'Weight';
  static String ht = 'Height';

  static TextEditingController firstTEC = TextEditingController();
  static TextEditingController lastTEC = TextEditingController();
  static TextEditingController ageTEC = TextEditingController();
  static TextEditingController dobTEC = TextEditingController();
  static TextEditingController medsTEC = TextEditingController();
  static TextEditingController condsTEC = TextEditingController();
  static TextEditingController wtTEC = TextEditingController();
  static TextEditingController htTEC = TextEditingController();

  static void updateProfile() {
    // if (firstTEC.text == '') {
    //   ProfileEdit.first = ProfileEdit.first;
    // } else
    //   ProfileEdit.first = firstTEC.text;
    //
    // if (lastTEC.text == '') {
    //   ProfileEdit.last = ProfileEdit.last;
    // } else
    //   ProfileEdit.last = lastTEC.text;
    //
    // if (ageTEC.text == '') {
    //   ProfileEdit.age = ProfileEdit.age;
    // } else
    //   ProfileEdit.age = ageTEC.text;
    //
    // if (dobTEC.text == '') {
    //   ProfileEdit.dob = ProfileEdit.dob;
    // } else
    //   ProfileEdit.dob = dobTEC.text;
    //
    // if (medsTEC.text == '') {
    //   ProfileEdit.meds = ProfileEdit.meds;
    // } else
    //   ProfileEdit.meds = medsTEC.text;
    //
    // if (condsTEC.text == '') {
    //   ProfileEdit.conds = ProfileEdit.conds;
    // } else
    //   ProfileEdit.conds = condsTEC.text;
    //
    // if (wtTEC.text == '') {
    //   ProfileEdit.wt = ProfileEdit.wt;
    // } else
    //   ProfileEdit.wt = wtTEC.text;
    //
    // if (htTEC.text == '') {
    //   ProfileEdit.ht = ProfileEdit.ht;
    // } else
    //   ProfileEdit.ht = htTEC.text;
  }

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB2EBF2),
      appBar: AppBar(
        title: Text(
          'Edit my Information',
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Expanded(
            child: TextField(
              controller: ProfileEdit.firstTEC,
              decoration: InputDecoration(
                hintText: ProfileEdit.first,
                contentPadding: const EdgeInsets.all(10.0),
                hintStyle: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
              onChanged: (first1) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: TextField(
              controller: ProfileEdit.lastTEC,
              decoration: InputDecoration(
                hintText: ProfileEdit.last,
                contentPadding: const EdgeInsets.all(10.0),
                hintStyle: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: ProfileEdit.ageTEC,
              decoration: InputDecoration(
                hintText: ProfileEdit.age,
                contentPadding: const EdgeInsets.all(10.0),
                hintStyle: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: ProfileEdit.dobTEC,
              decoration: InputDecoration(
                hintText: ProfileEdit.dob,
                contentPadding: const EdgeInsets.all(10.0),
                hintStyle: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          DropdownButton<String>(
            value: ProfileEdit.sexChoose,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
            items: [
              DropdownMenuItem(
                child: Text('--Sex--'),
                value: '--Sex--',
              ),
              DropdownMenuItem(
                child: Text('M'),
                value: 'M',
              ),
              DropdownMenuItem(
                child: Text('F'),
                value: 'F',
              ),
              DropdownMenuItem(
                child: Text('X'),
                value: 'X',
              ),
            ],
            onChanged: (value) {
              setState(
                () {
                  ProfileEdit.sexChoose = value.toString();
                },
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: ProfileEdit.htTEC,
              decoration: InputDecoration(
                hintText: ProfileEdit.ht,
                contentPadding: const EdgeInsets.all(10.0),
                hintStyle: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: ProfileEdit.wtTEC,
              decoration: InputDecoration(
                hintText: ProfileEdit.wt,
                contentPadding: const EdgeInsets.all(10.0),
                hintStyle: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: ProfileEdit.condsTEC,
              decoration: InputDecoration(
                hintText: ProfileEdit.conds,
                contentPadding: const EdgeInsets.all(10.0),
                hintStyle: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: ProfileEdit.medsTEC,
              decoration: InputDecoration(
                hintText: ProfileEdit.meds,
                contentPadding: const EdgeInsets.all(10.0),
                hintStyle: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.red[900],
                    ),
                    height: 40.0,
                    child: Center(
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(
                      () {
                        ProfileEdit.first = ProfileEdit.first;
                        ProfileEdit.last = ProfileEdit.last;
                        ProfileEdit.age = ProfileEdit.age;
                        ProfileEdit.dob = ProfileEdit.dob;
                        ProfileEdit.meds = ProfileEdit.meds;
                        ProfileEdit.conds = ProfileEdit.conds;
                        ProfileEdit.wt = ProfileEdit.wt;
                        ProfileEdit.ht = ProfileEdit.ht;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.green[300],
                    ),
                    height: 40.0,
                    child: Center(
                      child: Text(
                        'Confirm',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(
                      () {
                        if (ProfileEdit.firstTEC.text == '') {
                          ProfileEdit.first = ProfileEdit.first;
                        } else
                          ProfileEdit.first = ProfileEdit.firstTEC.text;

                        if (ProfileEdit.lastTEC.text == '') {
                          ProfileEdit.last = ProfileEdit.last;
                        } else
                          ProfileEdit.last = ProfileEdit.lastTEC.text;

                        if (ProfileEdit.ageTEC.text == '') {
                          ProfileEdit.age = ProfileEdit.age;
                        } else
                          ProfileEdit.age = ProfileEdit.ageTEC.text;

                        if (ProfileEdit.dobTEC.text == '') {
                          ProfileEdit.dob = ProfileEdit.dob;
                        } else
                          ProfileEdit.dob = ProfileEdit.dobTEC.text;

                        if (ProfileEdit.medsTEC.text == '') {
                          ProfileEdit.meds = ProfileEdit.meds;
                        } else
                          ProfileEdit.meds = ProfileEdit.medsTEC.text;

                        if (ProfileEdit.condsTEC.text == '') {
                          ProfileEdit.conds = ProfileEdit.conds;
                        } else
                          ProfileEdit.conds = ProfileEdit.condsTEC.text;

                        if (ProfileEdit.wtTEC.text == '') {
                          ProfileEdit.wt = ProfileEdit.wt;
                        } else
                          ProfileEdit.wt = ProfileEdit.wtTEC.text;

                        if (ProfileEdit.htTEC.text == '') {
                          ProfileEdit.ht = ProfileEdit.ht;
                        } else
                          ProfileEdit.ht = ProfileEdit.htTEC.text;
                        Navigator.pop(
                          context,
                          {
                            ProfileEdit.first,
                            ProfileEdit.last,
                            ProfileEdit.dob,
                            ProfileEdit.age,
                            ProfileEdit.sexChoose,
                            ProfileEdit.conds,
                            ProfileEdit.meds,
                            ProfileEdit.wt,
                            ProfileEdit.ht,
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
