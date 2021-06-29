import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
              Column(
                children: [
                  inputFile(label: 'Full Name'),
                  inputFile(label: 'Email'),
                  inputFile(label: 'Password'),
                  inputFile(label: 'Confirm Password', obsureText: true),
                ],
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
                  onPressed: () {},
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

Widget inputFile({label, obsureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: Colors.black)),
      SizedBox(height: 5.0),
      TextField(
        obscureText: obsureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
      ),
      SizedBox(
        height: 10.0,
      )
    ],
  );
}
