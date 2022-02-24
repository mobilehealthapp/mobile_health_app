import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Authentication/authentication_button.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import 'database_auth_services.dart';

//TODO: Make textfield style more consistent with the rest of the app, clean up UI
//This file contains the UI and firebase functionality for user signup

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey0 = GlobalKey<FormState>(); //Form key for first name validation
  final formKey1 = GlobalKey<FormState>(); //Form key for last name validation
  final formKey2 = GlobalKey<FormState>(); //Form key for email validation
  final formKey3 = GlobalKey<FormState>(); //Form key for password validation
  final formKey4 =
      GlobalKey<FormState>(); //Form key for confirm password validation
  final formKey5 = GlobalKey<FormState>(); //Form key for dropdown validation

  final CollectionReference patientProfileCollection =
      FirebaseFirestore.instance.collection('patientprofile');
  final CollectionReference doctorProfileCollection =
      FirebaseFirestore.instance.collection('doctorprofile');
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  var firstName;
  var lastName;
  var email;
  var password;
  var accountType;
  var _chosenValue;
  bool isHidden = true;
  bool areCredsValid = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: kSecondaryColour,
        appBar: AppBar(
          title: Text('Sign up'),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context); //Closes screen
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20.0,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 5.0),
                Text(
                  'Create an account. It\'s free!',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey[700],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 5.0),
                    Form(
                      key: formKey0,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                        onChanged: (value) {
                          firstName = value;
                        },
                        validator: Validators.required(
                            'First name is required'), //Each text form field contains a validator to ensure user has inputted information before signing up
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Form(
                      key: formKey1,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                        onChanged: (value) {
                          lastName = value;
                        },
                        validator: Validators.required('Last name is required'),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Form(
                      key: formKey2,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                        validator: Validators.compose([
                          Validators.required('Email is required'),
                        ]),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Form(
                      key: formKey3,
                      child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 15),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            suffix: InkWell(
                              onTap: togglePasswordView,
                              child: Icon(
                                isHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          obscureText: isHidden,
                          onChanged: (value) {
                            password = value;
                          },
                          validator: Validators.compose([
                            Validators.required(
                                'Password is required'), //Ensures user has filled out password field
                            Validators.minLength(6,
                                'Password must be at least 6 characters'), //Ensures password is at least 6 characters
                            Validators.patternRegExp(RegExp(r'[A-Z]'),
                                'Password must contain at least one upper case letter'), //Following patternRegExp validators ensure specific restrictions are enforced on password
                            Validators.patternRegExp(RegExp(r'[a-z]'),
                                'Password must contain at least one lower case letter'),
                            Validators.patternRegExp(RegExp(r'[0-9]'),
                                'Password must contain at least one numerical digit'),
                            Validators.patternRegExp(
                                RegExp(r'[_!@#$%^&*(),.?":{}|<>]'),
                                'Password must contain at least one special character'),
                          ])),
                    ),
                    SizedBox(height: 15.0),
                    Form(
                      key: formKey4,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 15),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          suffix: InkWell(
                            onTap: togglePasswordView,
                            child: Icon(
                              isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText: isHidden,
                        onChanged: (value) {},
                        validator: Validators.compose([
                          Validators.required('Please confirm password'),
                          (value) {
                            if (value != password) {
                              return "Passwords must match"; //Validator returns message if password and confirm password fields do not match
                            } else {
                              return null;
                            }
                          }
                        ]),
                      ),
                    ),
                    //SizedBox(height: 5.0),
                  ],
                ),
                Form(
                  key: formKey5,
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 250,
                      child: DropdownButtonFormField<String>(
                        //Dropdown menu for users to choose an account type
                        isExpanded: true,
                        validator: (value) => value ==
                                null //Validator to ensure user has picked an account type
                            ? 'Please select an account type'
                            : null,
                        value: _chosenValue,
                        focusColor: Colors.white,
                        elevation: 5,
                        items: <String>[
                          'Patient account',
                          'Physician account',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          );
                        }).toList(),
                        style: TextStyle(color: Colors.black),
                        iconEnabledColor: Colors.black,
                        hint: Text(
                          'Account Type',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _chosenValue = value;
                            accountType = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                AuthenticationButton(
                    label: 'Sign up',
                    onPressed: () async {
                      var formsInvalid = checkForms();
                      if (formsInvalid == false) {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          var result = await _auth.createUserWithEmailAndPassword(
                              email: email,
                              password:
                                  password); //Firebase Authentication method that creates user with inputted email and password
                          var user = result.user;
                          if (accountType == 'Patient account') {
                            //Checks user account type and sets user data in Firestore Database using functions defined in database_auth_services.dart
                            await DatabaseAuth(uid: user!.uid).initializeData();
                            await DatabaseAuth(uid: user.uid).setPatientData(
                                firstName, lastName, email, accountType);
                          } else if (accountType == 'Physician account') {
                            await DatabaseAuth(uid: user!.uid).setDoctorData(
                                firstName, lastName, email, accountType);
                          }
                          Navigator.of(context).pushNamed(
                              '/verify'); //Once account has been created, navigates user to email verification screen
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (signUpError) {
                          print(signUpError);
                          ScaffoldMessenger.of(context).showSnackBar(
                            //Catches authentication errors from firebase and displays them in snackbar message
                            //TODO: Implement logic that handles specific firebase errors and displays custom, easily-interpreted messages for each. Current code displays messages as written by firebase which are not always easy to interpret
                            SnackBar(
                              duration: Duration(seconds: 10),
                              backgroundColor: Colors.red,
                              content: Text(
                                signUpError.toString().split('] ')[1],
                                style: TextStyle(fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    colour: kPrimaryColour),
                TextButton(
                  //Button that navigates user to login screen
                  child: Text(
                    'Already registered? Log in!',
                    style: TextStyle(
                      fontSize: 20,
                      color: kPrimaryColour,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  bool checkForms() {
    var formKeyResult0 = formKey0.currentState
        ?.validate(); //Calls each form validator and stores result as bool value
    var formKeyResult1 = formKey1.currentState?.validate();
    var formKeyResult2 = formKey2.currentState?.validate();
    var formKeyResult3 = formKey3.currentState?.validate();
    var formKeyResult4 = formKey4.currentState?.validate();
    var formKeyResult5 = formKey5.currentState?.validate();
    List formList = [
      formKeyResult0,
      formKeyResult1,
      formKeyResult2,
      formKeyResult3,
      formKeyResult4,
      formKeyResult5
    ]; //Stores validation results in list

    bool validationFlag =
        false; //Validation flag returns true if any forms are invalid

    for (int i = 0; i < 6; i++) {
      if (formList[i] == false) {
        //Iterates through form results and checks if any are false (invalid)
        switch (i) {
          case 0:
            {
              //Switch statement checks with forms are invalid, waits 5 seconds and resets them
              //Validation flag returns true if any forms are invalid
              Timer(Duration(seconds: 5), () {
                formKey0.currentState?.reset();
              });

              validationFlag = true;
            }
            break;
          case 1:
            {
              Timer(Duration(seconds: 5), () {
                formKey1.currentState?.reset();
              });

              validationFlag = true;
            }
            break;
          case 2:
            {
              Timer(Duration(seconds: 5), () {
                formKey2.currentState?.reset();
              });

              validationFlag = true;
            }
            break;
          case 3:
            {
              Timer(Duration(seconds: 5), () {
                formKey3.currentState?.reset();
              });

              validationFlag = true;
            }
            break;
          case 4:
            {
              Timer(Duration(seconds: 5), () {
                formKey4.currentState?.reset();
              });

              validationFlag = true;
            }
            break;
          case 5:
            {
              Timer(Duration(seconds: 5), () {
                formKey5.currentState?.reset();
              });
              validationFlag = true;
            }
            break;
        }
      }
    }
    if (validationFlag == true) {
      return true; //Function returns true if any forms are invalid
    } else {
      return false; //Returns false if all forms are valid
    }
  }
}
