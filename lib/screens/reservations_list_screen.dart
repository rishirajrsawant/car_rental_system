import 'package:flutter/material.dart';
import '../services/car_rental_system.dart';
import '../models/reservation.dart';
import 'edit_reservation_screen.dart';
import 'package:intl/intl.dart';

class ReservationsListScreen extends StatefulWidget {
  final CarRentalSystem carRentalSystem;

  ReservationsListScreen({required this.carRentalSystem});

  @override
  _ReservationsListScreenState createState() => _ReservationsListScreenState();
}

class _ReservationsListScreenState extends State<ReservationsListScreen> {
  late List<Reservation> reservations;

  @override
  void initState() {
    super.initState();
    reservations = widget.carRentalSystem.getAllReservations();
  }

  void _refreshReservations() {
    setState(() {
      reservations = widget.carRentalSystem.getAllReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reservations'),
      ),
      body: reservations.isEmpty
          ? const Center(child: Text('No reservations found.'))
          : ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                Reservation reservation = reservations[index];
                return ListTile(
                  title: Text('${reservation.car.model}'),
                  subtitle: Text(
                      'From: ${DateFormat.yMEd().add_jms().format(reservation.startDateTime)}\nTo: ${DateFormat.yMEd().add_jms().format(reservation.endDateTime)}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditReservationScreen(
                              carRentalSystem: widget.carRentalSystem,
                              reservation: reservation,
                            ),
                          ),
                        ).then((_) {
                          // Refresh the list after returning from edit screen
                          _refreshReservations();
                        });
                      } else if (value == 'Cancel') {
                        bool success = widget.carRentalSystem
                            .cancelReservation(reservation.id);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Reservation cancelled.')),
                          );
                          // Refresh the list
                          _refreshReservations();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to cancel reservation.')),
                          );
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Edit', 'Cancel'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                );
              },
            ),
    );
  }
}
