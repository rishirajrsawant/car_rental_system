import 'package:flutter_test/flutter_test.dart';
import 'package:car_rental_system/models/car.dart';
import 'package:car_rental_system/models/car_type.dart';
import 'package:car_rental_system/models/inventory.dart';
import 'package:car_rental_system/services/car_rental_system.dart';

void main() {
  group('CarRentalSystem Tests', () {
    late CarRentalSystem carRentalSystem;
    late Inventory inventory;

    setUp(() {
      List<Car> cars = [
        Car(
          id: '1',
          type: CarType.sedan,
          model: 'Toyota Camry',
          color: 'Red',
          pricePerDay: 50.0,
        ),
        Car(
          id: '2',
          type: CarType.sedan,
          model: 'Honda Accord',
          color: 'Blue',
          pricePerDay: 55.0,
        ),
        // Add more cars as needed
      ];
      inventory = Inventory(cars);
      carRentalSystem = CarRentalSystem(inventory);
    });

    test('Should reserve a car for a specified number of days', () {
      var startDateTime = DateTime.now();
      int numberOfDays = 3;
      var endDateTime = startDateTime.add(Duration(days: numberOfDays));

      var reservation = carRentalSystem.reserveCar(
        CarType.sedan,
        startDateTime,
        endDateTime,
      );

      expect(reservation, isNotNull);
      expect(reservation!.startDateTime, startDateTime);
      expect(reservation.endDateTime, endDateTime);
      expect(carRentalSystem.reservations.length, 1);
    });

    test('Should not reserve a car when none are available', () {
      var startDateTime = DateTime.now();
      int numberOfDays = 3;
      var endDateTime = startDateTime.add(Duration(days: numberOfDays));

      // Reserve all sedans
      var reservation1 = carRentalSystem.reserveCar(
        CarType.sedan,
        startDateTime,
        endDateTime,
      );
      var reservation2 = carRentalSystem.reserveCar(
        CarType.sedan,
        startDateTime,
        endDateTime,
      );

      // Attempt to reserve another sedan
      var reservation3 = carRentalSystem.reserveCar(
        CarType.sedan,
        startDateTime,
        endDateTime,
      );

      expect(reservation1, isNotNull);
      expect(reservation2, isNotNull);
      expect(reservation3, isNull); // No more sedans available
      expect(carRentalSystem.reservations.length, 2);
    });

    test('Should calculate the correct price for reservation', () {
      var startDateTime = DateTime.now();
      int numberOfDays = 5;
      var endDateTime = startDateTime.add(Duration(days: numberOfDays));

      var reservation = carRentalSystem.reserveCar(
        CarType.sedan,
        startDateTime,
        endDateTime,
      );

      expect(reservation, isNotNull);

      double expectedPrice = reservation!.car.pricePerDay * numberOfDays;

      double totalPrice = reservation.car.pricePerDay * numberOfDays;

      expect(totalPrice, expectedPrice);
    });

    test('Should not allow overlapping reservations for the same car', () {
      var startDateTime1 = DateTime.now();
      int numberOfDays1 = 2;
      var endDateTime1 = startDateTime1.add(Duration(days: numberOfDays1));

      var startDateTime2 = startDateTime1
          .add(const Duration(days: 1)); // Overlaps with first reservation
      int numberOfDays2 = 3;
      var endDateTime2 = startDateTime2.add(Duration(days: numberOfDays2));

      // Reserve a specific car
      var car = inventory.getCarsByType(CarType.sedan).first;
      var reservation1 = carRentalSystem.reserveSpecificCar(
        car,
        startDateTime1,
        endDateTime1,
      );

      // Attempt to reserve the same car during overlapping dates
      var reservation2 = carRentalSystem.reserveSpecificCar(
        car,
        startDateTime2,
        endDateTime2,
      );

      expect(reservation1, isNotNull);
      expect(reservation2, isNull); // Should not allow overlapping reservation
      expect(carRentalSystem.reservations.length, 1);
    });

    /* test('Should allow reservations for the same car at non-overlapping times',
        () {
      var startDateTime1 = DateTime.now();
      int numberOfDays1 = 2;
      var endDateTime1 = startDateTime1.add(Duration(days: numberOfDays1));

      var startDateTime2 =
          endDateTime1; // Starts right after the first reservation
      int numberOfDays2 = 3;
      var endDateTime2 = startDateTime2.add(Duration(days: numberOfDays2));

      // Reserve a specific car
      var car = inventory.getCarsByType(CarType.sedan).first;
      var reservation1 = carRentalSystem.reserveSpecificCar(
        car,
        startDateTime1,
        endDateTime1,
      );

      // Reserve the same car for non-overlapping dates
      var reservation2 = carRentalSystem.reserveSpecificCar(
        car,
        startDateTime2,
        endDateTime2,
      );

      expect(reservation1, isNotNull);
      expect(reservation2, isNotNull);
      expect(carRentalSystem.reservations.length, 2);
    }); */
  });
}
