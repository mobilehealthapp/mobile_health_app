import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'settings_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_health_app/welcome_authentication_pages/database_auth_services..dart';
import 'settings_card.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
var loggedInUser;
var uid;

void getCurrentUser() async {
  try {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
      uid = user.uid.toString(); //convert uid to String
    }
  } catch (e) {
    print(e);
  }
}

class AlertPatientData extends StatelessWidget {
  // alert where patient can delete their data
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: emailPasswordPrompt(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            obscureText: true,
            controller: passwordController,
            decoration: kTextFieldDecoration.copyWith(hintText: 'Password'),
          )
        ],
      ),
      actions: <Widget>[
        CancelButton(),
        TextButton(
          style: TextButton.styleFrom(minimumSize: Size(20.0, 20.0)),
          onPressed: () async {
            await DatabaseAuth(uid: uid).deletePatientData(
                emailController.text, passwordController.text, context);
          },
          child: confirm(),
        ),
      ],
    );
  }
}

class AlertPatientAccount extends StatelessWidget {
  //alert where patient can delete their account
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: emailPasswordPrompt(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            obscureText: true,
            controller: passwordController,
            decoration: kTextFieldDecoration.copyWith(hintText: 'Password'),
          )
        ],
      ),
      actions: <Widget>[
        CancelButton(),
        TextButton(
          style: TextButton.styleFrom(minimumSize: Size(20.0, 20.0)),
          onPressed: () async {
            await DatabaseAuth(uid: uid).deletePatientUser(
                emailController.text, passwordController.text, context);
          },
          child: confirm(),
        ),
      ],
    );
  }
}

class AlertDoctorData extends StatelessWidget {
  // alert where doctor can delete their data
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: emailPasswordPrompt(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            obscureText: true,
            controller: passwordController,
            decoration: kTextFieldDecoration.copyWith(hintText: 'Password'),
          )
        ],
      ),
      actions: <Widget>[
        CancelButton(),
        TextButton(
          style: TextButton.styleFrom(minimumSize: Size(20.0, 20.0)),
          onPressed: () async {
            await DatabaseAuth(uid: uid).deleteDoctorData(
                emailController.text, passwordController.text, context);
          },
          child: confirm(),
        ),
      ],
    );
  }
}

class AlertDoctorAccount extends StatelessWidget {
  // alert where doctor can delete their account
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: emailPasswordPrompt(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: kTextFieldDecoration.copyWith(hintText: 'Email'),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            obscureText: true,
            controller: passwordController,
            decoration: kTextFieldDecoration.copyWith(hintText: 'Password'),
          )
        ],
      ),
      actions: <Widget>[
        CancelButton(),
        TextButton(
          style: TextButton.styleFrom(minimumSize: Size(20.0, 20.0)),
          onPressed: () async {
            await DatabaseAuth(uid: uid).deleteDoctorUser(
                emailController.text, passwordController.text, context);
          },
          child: confirm(),
        ),
      ],
    );
  }
}

Widget confirm() {
  // text widget used on buttons to confirm the user's input
  return Text(
    'Confirm',
    style: kAlertTextStyle,
  );
}

Widget emailPasswordPrompt() {
  // prompts user to enter their credentials to confirm the deletion action they wish to take
  return Text(
    'Please enter your email and password to complete this action.',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 20.0,
    ),
  );
}
