import 'package:flutter/material.dart';
import '../models/car_type.dart';
import '../services/car_rental_system.dart';
import '../screens/available_cars_screen.dart';

class ReservationScreen extends StatefulWidget {
  final CarRentalSystem carRentalSystem;

  ReservationScreen({required this.carRentalSystem});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  CarType? selectedCarType;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int numberOfDays = 1;
  final _formKey = GlobalKey<FormState>();

  void _reserveCar() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      DateTime startDateTime = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        startTime!.hour,
        startTime!.minute,
      );

      DateTime endDateTime = DateTime(
        endDate!.year,
        endDate!.month,
        endDate!.day,
        endTime!.hour,
        endTime!.minute,
      );

      var reservation = widget.carRentalSystem.reserveCar(
        selectedCarType!,
        startDateTime,
        endDateTime,
      );

      if (endDateTime.isBefore(startDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('End date and time must be after start date and time.')),
        );
        return;
      }

      if (reservation != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reservation successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No cars available for the selected dates.')),
        );
      }
    }
  }

  void _showAvailableCars() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      DateTime startDateTime = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        startTime!.hour,
        startTime!.minute,
      );

      DateTime endDateTime = DateTime(
        endDate!.year,
        endDate!.month,
        endDate!.day,
        endTime!.hour,
        endTime!.minute,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AvailableCarsScreen(
            carType: selectedCarType!,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            carRentalSystem: widget.carRentalSystem,
          ),
        ),
      );
    }
  }

  // Implement UI elements for selecting car type, start date, and number of days.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make a Reservation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Dropdown for Car Type
                DropdownButtonFormField<CarType>(
                  decoration: const InputDecoration(labelText: 'Car Type'),
                  items: CarType.values.map((CarType type) {
                    return DropdownMenuItem<CarType>(
                      value: type,
                      child:
                          Text(type.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (CarType? newValue) {
                    setState(() {
                      selectedCarType = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Select a car type' : null,
                ),
                // Date picker for Start Date
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today)),
                  readOnly: true,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        startDate = date;
                      });
                    }
                  },
                  validator: (value) =>
                      startDate == null ? 'Select a start date' : null,
                  controller: TextEditingController(
                    text: startDate != null
                        ? startDate!.toLocal().toString().split(' ')[0]
                        : '',
                  ),
                ),
                // End Date
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: startDate ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        endDate = date;
                      });
                    }
                  },
                  validator: (value) =>
                      endDate == null ? 'Select an end date' : null,
                  controller: TextEditingController(
                    text: endDate != null
                        ? endDate!.toLocal().toString().split(' ')[0]
                        : '',
                  ),
                ),

                // Start Time
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Start Time'),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        startTime = time;
                      });
                    }
                  },
                  validator: (value) =>
                      startTime == null ? 'Select a start time' : null,
                  controller: TextEditingController(
                    text: startTime != null ? startTime!.format(context) : '',
                  ),
                ),
                // End Time
                TextFormField(
                  decoration: const InputDecoration(labelText: 'End Time'),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: startTime ?? TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        endTime = time;
                      });
                    }
                  },
                  validator: (value) =>
                      endTime == null ? 'Select an end time' : null,
                  controller: TextEditingController(
                    text: endTime != null ? endTime!.format(context) : '',
                  ),
                ),
                ElevatedButton(
                  child: Text('Check Availability'),
                  onPressed: _showAvailableCars,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
