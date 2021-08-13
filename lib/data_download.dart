import 'package:flutter/material.dart';

void main() {
  runApp(Search());
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(),
        ),
      ),
    );
  }
}
