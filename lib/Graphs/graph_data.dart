import 'package:flutter/material.dart';
import 'package:mobile_health_app/constants.dart';

class SCRow extends StatelessWidget {
  SCRow({required this.type, required this.value});

  final String type;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

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
              SCRow(
                type: type,
                value: value,
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
  // used on health analysis page to display average, variance, standard deviation, and range of data type
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
              SCRow(
                type: 'Average: ',
                value: avgValue,
              ),
              SCRow(
                type: 'Variance: ',
                value: varValue,
              ),
              SCRow(
                type: 'Standard Deviation: ',
                value: sdValue,
              ),
              SCRow(
                type: 'Range: ',
                value: range,
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

class NewLegend extends StatelessWidget {
  NewLegend({required this.color, required this.name});
  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(width: 20, height: 20, color: color),
        SizedBox(width: 5.0),
        Text(
          name,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}