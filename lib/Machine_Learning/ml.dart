import 'package:flutter/material.dart';

import '/Drawers/drawers.dart';

class MachineLearning extends StatefulWidget {
  const MachineLearning({Key? key}) : super(key: key);

  @override
  _MachineLearningState createState() => _MachineLearningState();
}

class _MachineLearningState extends State<MachineLearning> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(
        title: const Text('ML Scratch Pad'),
      ),
    );
  }
}
