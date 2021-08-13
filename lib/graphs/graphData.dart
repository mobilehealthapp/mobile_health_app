import 'package:flutter/material.dart';
import 'package:mobile_health_app/Constants.dart';

class SummaryCard extends StatelessWidget {
  // used on home page to only display average value
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

class FullSummaryCard extends StatelessWidget {
  // used on health analysis page to display more than just average value
  FullSummaryCard({
    required this.avgValue,
    required this.varValue,
    required this.sdValue,
    required this.range,
  });

  final String avgValue;
  final String varValue;
  final String sdValue;
  final String range;

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
                    'Average: ',
                    style: kTextLabel2,
                  ),
                  Text(
                    avgValue,
                    style: kTextLabel2,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Variance: ',
                    style: kTextLabel2,
                  ),
                  Text(
                    varValue,
                    style: kTextLabel2,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Standard Deviation: ',
                    style: kTextLabel2,
                  ),
                  Text(
                    sdValue,
                    style: kTextLabel2,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Range',
                    style: kTextLabel2,
                  ),
                  Text(
                    '$range',
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
  // differentiates between which line is systolic and which line is diastolic on BP graph
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
