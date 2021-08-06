import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';

class SummaryCard extends StatelessWidget {
  SummaryCard({
    required this.value,
    required this.type,
  });

  final String type;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Card(
        shadowColor: Colors.blueGrey,
        color: Colors.blueGrey[100],
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    type,
                    style: kTextLabel2,
                  ),
                  Text(
                    value,
                    style: kTextLabel2,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  Legend({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(text),
      style: ElevatedButton.styleFrom(
        primary: color,
      ),
    );
  }
}
