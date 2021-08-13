import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_health_app/Authentication/authentication_button.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final _auth = FirebaseAuth.instance;
  var user;
  var email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Reset Password'),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 5, left: 5),
                    child: Center(
                      child: Text(
                        'Please enter your email below and press "Send Request" to receive email instructions to reset your password',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: TextField(
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
                          FontAwesomeIcons.user,
                          color: Colors.black,
                        ),
                        hintText: 'Enter Email',
                        hintStyle: TextStyle(fontSize: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AuthenticationButton(
                      label: 'Send Request',
                      onPressed: () {
                        _auth.sendPasswordResetEmail(email: email);
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Password Reset'),
                                content: const Text(
                                    'Please check your inbox for password reset instructions'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context)..pop()..pop();
                                      },
                                      child: const Text('Dismiss'))
                                ],
                              );
                            });

                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) =>
                      },
                      colour: Colors.blueGrey),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
