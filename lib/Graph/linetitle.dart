import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTitles {
  static getTitleData() {
    return FlTitlesData(
      show: true,
      leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 10:
                return '10';
              case 20:
                return '20';
              case 30:
                return '30';
              case 40:
                return '40';
              case 50:
                return '50';
              case 60:
                return '60';
              case 70:
                return '70';
              case 80:
                return '80';
              case 90:
                return '90';
              case 100:
                return '100';
              case 110:
                return '110';
              case 120:
                return '120';
              case 130:
                return '130';
              case 140:
                return '140';
              case 150:
                return '150';
              case 160:
                return '160';
              case 170:
                return '170';
              case 180:
                return '180';
            }
            return '';
          },
          reservedSize: 20,
          margin: 10),
    );
  }
}

class LineTitles2 {
  static getTitleData() {
    return FlTitlesData(
      show: true,
      leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => TextStyle(
                color: Colors.black,
                fontSize: 10,
              ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
              case 4:
                return '4';
              case 5:
                return '5';
              case 6:
                return '6';
              case 7:
                return '7';
              case 8:
                return '8';
              case 9:
                return '9';
              case 10:
                return '10';
            }
            return '';
          },
          reservedSize: 20,
          margin: 10),
    );
  }
}
