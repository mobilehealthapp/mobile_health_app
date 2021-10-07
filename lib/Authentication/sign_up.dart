import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app/Authentication/authentication_button.dart';
import 'package:mobile_health_app/Authentication/database_auth_services.dart';
import 'package:mobile_health_app/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

//TODO: Make textfield style more consistent with the rest of the app, clean up UI
//This file contains the UI and firebase functionality for user signup

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey =
      GlobalKey<FormState>(); //Form key for textformfield validation
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
  bool validemail = true;
  bool validformat = true;

  void checkEmail(String email, CollectionReference collection) {
    validemail = true;
    //checks if an email is being used in a collection already
    //value is the email itself. This method could be adapted to work on other fields
    collection.get().then((docSnap) => {
          //take snapshot of the collection's documents
          if (docSnap.size >
              0) //if the collection isn't empty, iterate through each document
            {
              docSnap.docs.forEach((DocumentSnapshot doc) {
                String comparedemail = doc.get('email');
                if (email == comparedemail) {
                  //if the email matches any of the
                  //emails stored in the same valuetype, set validity to false
                  validemail = false;
                }
              })
            }
        });
  }

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
                Column(
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      'Create an account. It\'s free!',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey[700],
                      ),
                    )
                  ],
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 5.0),
                      TextFormField(
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
                      SizedBox(height: 15.0),
                      TextFormField(
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
                      SizedBox(height: 15.0),
                      TextFormField(
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
                          checkEmail(email!, patientProfileCollection);
                          checkEmail(email!, doctorProfileCollection);
                          validformat = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email);
                        },
                        validator: Validators.compose([
                          Validators.required('Email is required'),
                          (value) {
                            if (!validformat) {
                              return 'Please enter a valid email adress.';
                            } else if (!validemail) {
                              return 'This email address is already in use.';
                            }
                          },
                        ]),
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
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
                            //TODO: Currently, only password restriction is a minimum length of 6 characters, for tighter security it is necessary to include more restrictions on password
                            Validators.required('Password is required'),
                            Validators.minLength(
                                6, 'Password must be at least 6 characters'),
                          ])),
                      SizedBox(height: 15.0),
                      TextFormField(
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
                      SizedBox(height: 10.0),
                      Center(
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
                      var areCredsValid = formKey.currentState
                          ?.validate(); //Ensures all validators are satisfied
                      if (areCredsValid == true) {
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
                            await DatabaseAuth(uid: user!.uid).setPatientData(
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
}
