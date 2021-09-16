import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_health_app/Authentication/authentication_button.dart';
import 'package:mobile_health_app/Constants.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import 'account_check.dart';

//This file contains the UI elements of the login page as well as the firebase functionality of user authentication and login
//TODO: Clean up UI, improve visual aesthetics of page if deemed necessary
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<
      FormState>(); //Form must be declared for validators to function properly
  final _auth = FirebaseAuth
      .instance; //_auth variable is used to perform firebase authentication functions
  bool showSpinner = false;
  var user;
  var email;
  var password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Log in'),
      ),
      backgroundColor: kSecondaryColour,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(),
              child: SafeArea(
                child: Form(
                  //all text fields must be wrapped in form containing formKey for validators to function
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25.0,
                      ),
                      Hero(
                        //Hero widget allows for logo animations on welcome/login screen transition
                        tag: 'logo',
                        child: Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/logo.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          validator: Validators.required(
                              'Email is required'), //validator property of TextFormField allows for app to check that correct information has been inputted
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email =
                                value; //Value inputted into textfield is saved as a variable
                          },
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kSecondaryColour,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            hintText: 'Enter Email',
                            hintStyle: TextStyle(fontSize: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColour, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColour, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextFormField(
                          validator:
                              Validators.required('Password is required'),
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                          },
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kSecondaryColour,
                            icon: Icon(
                              FontAwesomeIcons.key,
                              color: Colors.black,
                            ),
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(fontSize: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColour, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColour, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: kPrimaryColour, fontSize: 17),
                              ),
                              onPressed: () => Navigator.of(context).pushNamed(
                                  '/reset'), //Button navigates to password reset screen
                              padding: EdgeInsets.only(bottom: 20, top: 5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AuthenticationButton(
                          label: 'Log in',
                          onPressed: () async {
                            var areCredsValid = formKey.currentState
                                ?.validate(); //upon login button press, state of current form is checked to see if all textfield validators are satisfied. Saved as True if valid.
                            if (areCredsValid == true) {
                              //If validators are satisfied, attempts to log user in using inputted email and password values from textfield.
                              try {
                                //wrapped in try/catch block to handle login errors
                                await _auth.signInWithEmailAndPassword(
                                    email: email,
                                    password:
                                        password); //signs in user using credentials
                                user = _auth.currentUser;
                                if (user.emailVerified) {
                                  //checks if user's email is verified
                                  var uid = user!.uid;
                                  bool
                                      isPatient = //if email is verified, checks patient's account type using functions from accountcheck.dart
                                      await patientAccountCheck(uid);
                                  bool isDoctor = await doctorAccountCheck(uid);
                                  if (isPatient) {
                                    //Navigates to patient home page
                                    Navigator.of(context)
                                        .pushReplacementNamed('/home');
                                  } else if (isDoctor) {
                                    //Navigates to physician home page
                                    Navigator.of(context)
                                        .pushReplacementNamed('/physHome');
                                  }
                                } else {
                                  //If email is not verified, navigates user to email verification screen
                                  Navigator.of(context).pushNamed('/verify');
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                              } catch (signInError) {
                                //If errors occur such as incorrect email or password, they will be handled here and displayed in a 'snackbar' message
                                //TODO: Implement logic that handles specific firebase errors and displays custom, easily-interpreted messages for each. Current code displays messages as written by firebase which are not always easy to interpret for a user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 10),
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      signInError.toString().split('] ')[1],
                                      style: TextStyle(fontSize: 20.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          colour: Colors.blueGrey),
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        child: Text(
                          'New user? Sign up!',
                          style: TextStyle(color: kPrimaryColour, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              '/signup'); //Navigates user to signup page
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
