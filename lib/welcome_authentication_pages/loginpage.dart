import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_health_app/authentication_button.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:mobile_health_app/main.dart';
import 'accountcheck.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  var user;
  var email;
  var password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColour,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Log in',
              style: TextStyle(
                color: Colors.white,
              ))),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(),
              child: SafeArea(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25.0,
                      ),
                      Hero(
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
                          validator: Validators.required('Email is required'),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value;
                          },
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
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
                              borderSide: BorderSide(
                                  color: Color(0xFF0097A7), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF0097A7), width: 2.0),
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
                            fillColor: Colors.white,
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
                              borderSide: BorderSide(
                                  color: Color(0xFF0097A7), width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF0097A7), width: 2.0),
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
                                    color: Colors.lightBlue, fontSize: 17),
                              ),
                              onPressed: () =>
                                  Navigator.of(context).pushNamed('/reset'),
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
                            var areCredsValid =
                                formKey.currentState?.validate();
                            if (areCredsValid == true) {
                              try {
                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);
                                user = _auth.currentUser;
                                if (user.emailVerified) {
                                  var uid = user!.uid;
                                  bool isPatient =
                                      await patientAccountCheck(uid);
                                  bool isDoctor = await doctorAccountCheck(uid);
                                  if (isPatient) {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/home');
                                  } else if (isDoctor) {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/physHome');
                                  }
                                } else {
                                  Navigator.of(context).pushNamed('/verify');
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                              } catch (signInError) {
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
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/signup');
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
