import 'package:flutter/material.dart';
import '../services/car_rental_system.dart';
import 'reservation_screen.dart';
import 'reservations_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final CarRentalSystem carRentalSystem;

  HomeScreen({required this.carRentalSystem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Car Rental System',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text('Reserve a Car'),
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
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: const Text('My Reservations'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationsListScreen(
                      carRentalSystem: carRentalSystem,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
