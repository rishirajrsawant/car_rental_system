import 'car.dart';

class Reservation {
  final String id;
  final Car car;
  final DateTime startDateTime;
  final DateTime endDateTime;

  Reservation({
    required this.id,
    required this.car,
    required this.startDateTime,
    required this.endDateTime,
  });

  bool isActive(DateTime dateTime) {
    return dateTime.isAfter(startDateTime) && dateTime.isBefore(endDateTime);
  }
}
