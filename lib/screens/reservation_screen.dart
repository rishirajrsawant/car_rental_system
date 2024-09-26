import 'package:flutter/material.dart';
import '../models/car_type.dart';
import '../services/car_rental_system.dart';
import 'available_cars_screen.dart';
import '../widgets/date_picker_field.dart';

class ReservationScreen extends StatefulWidget {
  final CarRentalSystem carRentalSystem;

  ReservationScreen({required this.carRentalSystem});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  CarType? selectedCarType;
  DateTime? startDate;
  TimeOfDay? startTime;
  int? numberOfDays;
  final _formKey = GlobalKey<FormState>();

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

      // Validate that the startDateTime is in the future
      if (!startDateTime.isAfter(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Start date and time must be in the future.')),
        );
        return;
      }

      DateTime endDateTime = startDateTime.add(Duration(days: numberOfDays!));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AvailableCarsScreen(
            carType: selectedCarType!,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            carRentalSystem: widget.carRentalSystem,
            numberOfDays: numberOfDays!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make a Reservation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Select Car Type', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<CarType>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: CarType.values.map((CarType type) {
                  return DropdownMenuItem<CarType>(
                    value: type,
                    child: Text(type.toString().split('.').last.toUpperCase()),
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
              const SizedBox(height: 16),
              // Start Date
              const Text('Start Date', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DatePickerField(
                labelText: 'Start Date',
                selectedDate: startDate,
                onDateSelected: (date) {
                  setState(() {
                    startDate = date;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Start Time
              const Text('Start Time', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              _buildTimePickerField(
                labelText: 'Start Time',
                selectedTime: startTime,
                onTimeSelected: (time) {
                  setState(() {
                    startTime = time;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Number of Days
              const Text('Number of Days', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Number of Days',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  int? days = int.tryParse(value!);
                  if (days == null || days <= 0) {
                    return 'Enter a valid number of days';
                  }
                  return null;
                },
                onSaved: (value) {
                  numberOfDays = int.parse(value!);
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  child: Text('Check Availability'),
                  onPressed: _showAvailableCars,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerField({
    required String labelText,
    required TimeOfDay? selectedTime,
    required ValueChanged<TimeOfDay?> onTimeSelected,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.access_time),
      ),
      readOnly: true,
      onTap: () async {
        TimeOfDay initialTime = selectedTime ?? TimeOfDay.now();
        TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );
        if (time != null) {
          bool isValid = _validateSelectedTime(time);
          if (isValid) {
            onTimeSelected(time);
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a future time.')),
            );
          }
        }
      },
      validator: (value) => selectedTime == null ? 'Select a time' : null,
      controller: TextEditingController(
        text: selectedTime != null ? selectedTime.format(context) : '',
      ),
    );
  }

  bool _validateSelectedTime(TimeOfDay selectedTime) {
    DateTime now = DateTime.now();
    DateTime selectedDateTime = DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    return selectedDateTime.isAfter(now);
  }
}
