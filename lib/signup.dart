import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ignore: unused_import
import 'package:mobile_health_app/HomePage.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class SignupPa`ge extends StatefulWidget {
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
  var firstName;
  var lastName;
  var email;
  var password;
  FirebaseFirestore? fstore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Welcome',
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
                  Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      validation: Validators.required('First name is required'),
                    ),
                    inputFile(
                      label: 'Last Name',
                      onChangedFunction: (value) {
                        lastName = value;
                      },
                      validation: Validators.required('Last name is required'),
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
                child: MaterialButton(
                  color: Colors.blue,
                  height: 60.0,
                  minWidth: 300,
                  onPressed: () async {
                    var areCredsValid = formKey.currentState?.validate();
                    if (areCredsValid == true) {
                      try {
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        //
                        await FirebaseFirestore.instance
                            .collection('SignInInfo')
                            .doc(_auth.currentUser!.uid)
                            .set({
                          'email': email,
                          'fName': firstName,
                          'lName': lastName,
                        });

                        //
                        //TODO: Handle case where account already exists properly
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      } catch (signUpError) {
                        print(signUpError);
                      }
                    }
                  },
                  //   if (password == confirmPassword) {
                  //     if (password.length() >= 6) {
                  //       final newUser = await _auth
                  //           .createUserWithEmailAndPassword(
                  //           email: email, password: password);
                  //     } else
                  //   } else
                  // },
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
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
