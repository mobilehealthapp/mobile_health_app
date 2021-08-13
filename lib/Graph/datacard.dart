import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';

class DataCard extends StatelessWidget {
  DataCard({
    required this.value1,
    required this.type1,
    // required this.value2,
    required this.type2,
    // required this.value3,
  });

  final String type1;
  final int value1;
  final String type2;
  // final int value2;
  // final int value3;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Summary for the data',
              style: kTextLabel1,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  type1,
                  style: kTextLabel2,
                ),
                SizedBox(),
                Text(
                  value1.toString(),
                  style: kTextLabel2,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  type2,
                  style: kTextLabel2,
                ),
                SizedBox(
                  width: 10,
                ),
                // Text(
                //   '${value2.toString()}/${value3.toString()}',
                //   style: kTextLabel2,
                // )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
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
