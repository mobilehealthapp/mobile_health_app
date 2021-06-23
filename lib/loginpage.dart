import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(title: Text('Log In')),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('images/logo-1.png'),),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    icon: Icon(
                      FontAwesomeIcons.user,
                      color: Colors.black,
                    ),
                    hintText: 'Enter Username',
                    hintStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 20
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                )
                ,
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  style: TextStyle(
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
                    hintStyle: TextStyle(
                      color: Colors.green,
                      fontSize: 20
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                )
                ,
              ),
              SizedBox(height: 10,),
              Container(
                height: 50,
                width: 200,
                color: Colors.cyan,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Patient Log In',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black
                    ),
                  ),

                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 50,
                width: 200,
                color: Colors.cyan,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Physician Log In',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black
                    ),
                  ),

                ),
              ),
              SizedBox(height: 50,),
              Container(
                color: Colors.green,
                child: TextButton(
                  onPressed: (){},
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black
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
