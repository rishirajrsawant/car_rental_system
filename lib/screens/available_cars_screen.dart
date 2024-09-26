import 'package:flutter/material.dart';
import '../models/car.dart';
import '../models/car_type.dart';
import '../services/car_rental_system.dart';

class AvailableCarsScreen extends StatelessWidget {
  final CarType carType;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int numberOfDays;
  final CarRentalSystem carRentalSystem;

  AvailableCarsScreen({
    required this.carType,
    required this.startDateTime,
    required this.endDateTime,
    required this.numberOfDays,
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
      body: availableCars.isEmpty
          ? const Center(child: Text('No cars available.'))
          : ListView.builder(
              itemCount: availableCars.length,
              itemBuilder: (context, index) {
                Car car = availableCars[index];
                return ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text('${car.model} (${car.color})'),
                  subtitle: Text(
                      'Price per day: \€${car.pricePerDay.toStringAsFixed(2)}'),
                  onTap: () {
                    _confirmReservation(context, car);
                  },
                );
              },
            ),
    );
  }

  void _confirmReservation(BuildContext context, Car car) {
    int totalDays = numberOfDays;
    double totalPrice = car.pricePerDay * totalDays;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Reservation'),
        content: Text(
            'Car: ${car.model}\nTotal Price: \€${totalPrice.toStringAsFixed(2)} for $totalDays days.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              var reservation = carRentalSystem.reserveSpecificCar(
                car,
                startDateTime,
                endDateTime,
              );
              Navigator.pop(context); // Close the dialog
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
          ),
        ],
      ),
    );
  }
}
