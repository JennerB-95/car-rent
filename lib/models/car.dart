import 'package:flutter/material.dart';

class Car {
  int id;
  String brand;
  String model;
  double price;
  String condition;
  List<String> images;

  Car(
      {@required this.id,
      this.brand,
      this.model,
      this.price,
      this.condition,
      this.images});
}
