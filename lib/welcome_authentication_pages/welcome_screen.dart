import 'package:flutter/material.dart';
import 'package:mobile_health_app/authentication_button.dart';
import 'package:mobile_health_app/welcome_authentication_pages/loginpage.dart';

import '../drawers.dart';
import 'signup.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue[300],
      ),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      // appBar: AppBar(
      //   title: Center(
      //       child: Text(
      //     'Welcome',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 34,
      //     ),
      //   )),
      // ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 27.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 125,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'images/logo-1-removebg-preview.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      Text(
                        'AppName',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Providing families with faster and safer treatment',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // MaterialButton(
                  //   color: Colors.white,
                  //   height: 50.0,
                  //   minWidth: 300,
                  //   onPressed: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => LoginPage()));
                  //   },
                  //   shape: RoundedRectangleBorder(
                  //     // side: BorderSide(
                  //     //   color: Colors.black,
                  //     // ),
                  //     borderRadius: BorderRadius.circular(50.0),
                  //   ),
                  //   child: Text(
                  //     'Login',
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 18.0,
                  //     ),
                  //   ),
                  // ),
                  AuthenticationButton('Log in', () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }, Colors.blueGrey),
                  SizedBox(
                    height: 20.0,
                  ),

                  AuthenticationButton('Sign up', () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  }, Colors.cyan)
                  // MaterialButton(
                  //   color: Colors.blue,
                  //   height: 50.0,
                  //   minWidth: 300.0,
                  //   onPressed: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => SignupPage()));
                  //   },
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(50.0),
                  //   ),
                  //   child: Text(
                  //     'Signup',
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 18.0,
                  //         color: Colors.white),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
