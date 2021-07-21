import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ignore: unused_import
import 'package:mobile_health_app/authentication_button.dart';
import 'package:mobile_health_app/welcome_authentication_pages/database.dart';
import 'package:mobile_health_app/welcome_authentication_pages/loginpage.dart';
import 'package:mobile_health_app/welcome_authentication_pages/verify.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// class SignupPage extends StatefulWidget {
//   @override
//   _SignupPageState createState() => _SignupPageState();
// }
//
// class _SignupPageState extends State<SignupPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

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
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.cyan,
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
                      DropdownButton<String>(
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
                      )
                    ],
                  ),
                ),
                Container(
                  // padding: EdgeInsets.only(top: 3, left: 3),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(50),
                  //   border: Border(
                  //     BorderSide(color: Colors.white),
                  //     bottom: BorderSide(color: Colors.red),
                  //     top: BorderSide(color: Colors.red),
                  //     left: BorderSide(color: Colors.white),
                  //     right: BorderSide(color: Colors.white),
                  //   ),
                  // ),
                  child: AuthenticationButton('Sign up', () async {
                    setState(() {
                      showSpinner = true;
                    });

                    var areCredsValid = formKey.currentState?.validate();
                    if (areCredsValid == true) {
                      try {
                        var result = await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        var user = result.user;
                        if (accountType == 'Patient account') {
                          await Database(uid: user!.uid).updatePatientData(
                              firstName, lastName, email, accountType);
                        } else if (accountType == 'Physician account') {
                          await Database(uid: user!.uid).updateDoctorData(
                              firstName, lastName, email, accountType);
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EmailVerificationScreen()));
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
                  }, Colors.cyan),
                ),
                TextButton(
                  child: Text(
                    'Already registered? Log in!',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
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
