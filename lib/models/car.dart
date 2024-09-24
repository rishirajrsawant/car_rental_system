import 'car_type.dart';

class Car {
  final String id;
  final CarType type;
  final String model;
  final String color;
  final double pricePerDay;

  Car({
    required this.id,
    required this.type,
    required this.model,
    required this.color,
    required this.pricePerDay,
  });
}
