import 'package:flutter/material.dart';

class ConverterService {
  static double metersToFeet(double meters) {
    return meters * 3.28084;
  }

  static double kgToPounds(double kg) {
    return kg * 2.20462;
  }

  static double celsiusToFahrenheit(double c) {
    return (c * 9 / 5) + 32;
  }
}
