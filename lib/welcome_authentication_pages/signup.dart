import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ignore: unused_import
import 'package:mobile_health_app/authentication_button.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:mobile_health_app/welcome_authentication_pages/database_auth_services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mobile_health_app/Constants.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  var firstName;
  var lastName;
  var email;
  var password;
  var accountType;
  var _chosenValue;
  bool areCredsValid = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPrimaryColour,
          title: Text(
            'Sign up',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20.0,
              color: Colors.black,
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
                Column(
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      'Create an account. It\'s free!',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey[700],
                      ),
                    )
                  ],
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      inputFile(
                        label: 'First Name',
                        onChangedFunction: (value) {
                          firstName = value;
                        },
                        validation:
                            Validators.required('First name is required'),
                      ),
                      inputFile(
                        label: 'Last Name',
                        onChangedFunction: (value) {
                          lastName = value;
                        },
                        validation:
                            Validators.required('Last name is required'),
                      ),
                      inputFile(
                        label: 'Email',
                        onChangedFunction: (value) {
                          email = value;
                        },
                        validation: Validators.compose([
                          Validators.required('Email is required'),
                          Validators.email('Invalid email address'),
                        ]),
                      ),
                      inputFile(
                          label: 'Password',
                          obscureTextState: true,
                          onChangedFunction: (value) {
                            password = value;
                          },
                          validation: Validators.compose([
                            Validators.required('Password is required'),
                            Validators.minLength(
                                6, 'Password must be at least 6 characters'),
                          ])),
                      inputFile(
                        label: 'Confirm Password',
                        obscureTextState: true,
                        onChangedFunction: (value) {},
                        validation: Validators.compose([
                          Validators.required('Please confirm password'),
                          (value) {
                            if (value != password) {
                              return "Passwords must match";
                            } else {
                              return null;
                            }
                          }
                        ]),
                      ),
                      Center(
                        child: Container(
                          height: 50,
                          width: 250,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            validator: (value) => value == null
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
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
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
                      )
                    ],
                  ),
                ),
                AuthenticationButton(
                    label: 'Sign up',
                    onPressed: () async {
                      var areCredsValid = formKey.currentState?.validate();
                      if (areCredsValid == true) {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          var result =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          var user = result.user;
                          if (accountType == 'Patient account') {
                            await DatabaseAuth(uid: user!.uid).setPatientData(
                                firstName, lastName, email, accountType);
                          } else if (accountType == 'Physician account') {
                            await DatabaseAuth(uid: user!.uid).setDoctorData(
                                firstName, lastName, email, accountType);
                          }
                          Navigator.of(context).pushNamed('/verify');
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (signUpError) {
                          ScaffoldMessenger.of(context).showSnackBar(
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
                  child: Text(
                    'Already registered? Log in!',
                    style: TextStyle(fontSize: 20),
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
}

Widget inputFile(
    {label, obscureTextState = false, onChangedFunction, validation}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: Colors.black)),
      SizedBox(height: 5.0),
      TextFormField(
        validator: validation,
        onChanged: onChangedFunction,
        obscureText: obscureTextState,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
      ),
      SizedBox(
        height: 10.0,
      )
    ],
  );
}
