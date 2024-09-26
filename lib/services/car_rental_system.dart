import 'package:uuid/uuid.dart';
import '../models/car.dart';
import '../models/car_type.dart';
import '../models/reservation.dart';
import '../models/inventory.dart';

class CarRentalSystem {
  final Inventory inventory;
  final List<Reservation> reservations = [];

  CarRentalSystem(this.inventory);

  Reservation? reserveCar(
      CarType type, DateTime startDateTime, DateTime endDateTime) {
    List<Car> availableCars =
        getAvailableCars(type, startDateTime, endDateTime);

    if (availableCars.isNotEmpty) {
      Car car = availableCars.first;
      String reservationId = const Uuid().v4();

      Reservation reservation = Reservation(
        id: reservationId,
        car: car,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
      );

      reservations.add(reservation);
      return reservation;
    } else {
      // No available cars
      return null;
    }
  }

  Reservation? reserveSpecificCar(
      Car car, DateTime startDateTime, DateTime endDateTime) {
    bool isCarAvailable = !_isCarReserved(car, startDateTime, endDateTime);

    if (isCarAvailable) {
      String reservationId = const Uuid().v4();

      Reservation reservation = Reservation(
        id: reservationId,
        car: car,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
      );

      reservations.add(reservation);
      return reservation;
    } else {
      // Car is not available
      return null;
    }
  }

  bool _isCarReserved(Car car, DateTime startDateTime, DateTime endDateTime) {
    return reservations.any((r) =>
        r.car.id == car.id &&
        startDateTime.isBefore(r.endDateTime) &&
        endDateTime.isAfter(r.startDateTime));
  }

  List<Car> getAvailableCars(
      CarType type, DateTime startDateTime, DateTime endDateTime) {
    List<Car> carsByType = inventory.getCarsByType(type);

    List<Car> reservedCars = reservations
        .where((r) =>
            r.car.type == type &&
            !(endDateTime.isBefore(r.startDateTime) ||
                startDateTime.isAfter(r.endDateTime)))
        .map((r) => r.car)
        .toList();

    return carsByType.where((car) => !reservedCars.contains(car)).toList();
  }

  List<Reservation> getAllReservations() {
    return reservations;
  }

  bool editReservation(String reservationId, DateTime newStartDateTime,
      DateTime newEndDateTime) {
    int index = reservations.indexWhere((r) => r.id == reservationId);
    if (index == -1) {
      // Reservation not found
      return false;
    }

    Reservation reservation = reservations[index];

    // Check for conflicts with other reservations
    bool hasConflict = reservations.any((r) {
      if (r.id == reservationId) {
        // Skip the reservation being edited
        return false;
      }
      return r.car.id == reservation.car.id &&
          newStartDateTime.isBefore(r.endDateTime) &&
          newEndDateTime.isAfter(r.startDateTime);
    });

    if (hasConflict) {
      // Cannot edit due to conflict
      return false;
    }

    // Update the reservation
    reservation.startDateTime = newStartDateTime;
    reservation.endDateTime = newEndDateTime;

    return true;
  }

  bool cancelReservation(String reservationId) {
    int initialLength = reservations.length;
    reservations.removeWhere((r) => r.id == reservationId);
    return reservations.length < initialLength;
  }
}
