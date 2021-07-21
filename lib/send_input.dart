import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewInput extends StatefulWidget {
  const NewInput({Key? key}) : super(key: key);

  @override
  _NewInputState createState() => _NewInputState();
}

class _NewInputState extends State<NewInput> {
  var gender;

  void getValue() {
    FirebaseFirestore.instance.collection('patientData').add(
      {
        'gender': gender,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
