import 'package:flutter/material.dart';
import '../services/car_rental_system.dart';
import 'reservation_screen.dart';

class HomeScreen extends StatelessWidget {
  final CarRentalSystem carRentalSystem;

  HomeScreen({required this.carRentalSystem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Rental System'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Reserve a Car'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReservationScreen(
                  carRentalSystem: carRentalSystem,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),
        ),
      ),
    );
  }
}
