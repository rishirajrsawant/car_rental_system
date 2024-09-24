import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/car_type.dart';
import '../services/car_rental_system.dart';

class AvailableCarsScreen extends StatelessWidget {
  final CarType carType;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final CarRentalSystem carRentalSystem;

  AvailableCarsScreen({
    required this.carType,
    required this.startDateTime,
    required this.endDateTime,
    required this.carRentalSystem,
  });

  @override
  Widget build(BuildContext context) {
    List<Car> availableCars = carRentalSystem.getAvailableCars(
      carType,
      startDateTime,
      endDateTime,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Cars'),
      ),
      body: ListView.builder(
        itemCount: availableCars.length,
        itemBuilder: (context, index) {
          Car car = availableCars[index];
          return ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text('${car.model} (${car.color})'),
            subtitle:
                Text('Price per day: \$${car.pricePerDay.toStringAsFixed(2)}'),
            onTap: () {
              var reservation = carRentalSystem.reserveSpecificCar(
                car,
                startDateTime,
                endDateTime,
              );

              if (reservation != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reservation successful!')),
                );
                Navigator.popUntil(context, ModalRoute.withName('/'));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to reserve the car.')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
