import 'package:flutter/material.dart';
import '../services/car_rental_system.dart';
import '../models/reservation.dart';

class EditReservationScreen extends StatefulWidget {
  final CarRentalSystem carRentalSystem;
  final Reservation reservation;

  EditReservationScreen({
    required this.carRentalSystem,
    required this.reservation,
  });

  @override
  _EditReservationScreenState createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> {
  DateTime? newStartDate;
  TimeOfDay? newStartTime;
  int? newNumberOfDays;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    newStartDate = widget.reservation.startDateTime;
    newStartTime = TimeOfDay.fromDateTime(widget.reservation.startDateTime);
    newNumberOfDays = widget.reservation.endDateTime
        .difference(widget.reservation.startDateTime)
        .inDays;
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      DateTime newStartDateTime = DateTime(
        newStartDate!.year,
        newStartDate!.month,
        newStartDate!.day,
        newStartTime!.hour,
        newStartTime!.minute,
      );

      DateTime newEndDateTime =
          newStartDateTime.add(Duration(days: newNumberOfDays!));

      // Validate that the new start date/time is in the future
      if (!newStartDateTime.isAfter(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Start date and time must be in the future.')),
        );
        return;
      }

      bool success = widget.carRentalSystem.editReservation(
        widget.reservation.id,
        newStartDateTime,
        newEndDateTime,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reservation updated successfully.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update reservation.')),
        );
      }
    }
  }

  // Reuse date and time picker widgets from ReservationScreen or create new ones

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Reservation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Start Date
              const Text(
                'Start Date',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Implement date picker field
              _buildDatePickerField(),
              const SizedBox(height: 16),
              // Start Time
              const Text(
                'Start Time',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Implement time picker field
              _buildTimePickerField(),
              const SizedBox(height: 16),
              // Number of Days
              const Text(
                'Number of Days',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: newNumberOfDays.toString(),
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
                  newNumberOfDays = int.parse(value!);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Start Date',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime initialDate = newStartDate ?? now;
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: initialDate.isBefore(now) ? now : initialDate,
          firstDate: now,
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() {
            newStartDate = date;
          });
        }
      },
      validator: (value) => newStartDate == null ? 'Select a date' : null,
      controller: TextEditingController(
        text: newStartDate != null
            ? newStartDate!.toLocal().toString().split(' ')[0]
            : '',
      ),
    );
  }

  Widget _buildTimePickerField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Start Time',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.access_time),
      ),
      readOnly: true,
      onTap: () async {
        if (newStartDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a start date first.')),
          );
          return;
        }
        TimeOfDay initialTime = newStartTime ?? TimeOfDay.now();
        TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );
        if (time != null) {
          bool isValid = _validateSelectedTime(time);
          if (isValid) {
            setState(() {
              newStartTime = time;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a future time.')),
            );
          }
        }
      },
      validator: (value) => newStartTime == null ? 'Select a time' : null,
      controller: TextEditingController(
        text: newStartTime != null ? newStartTime!.format(context) : '',
      ),
    );
  }

  bool _validateSelectedTime(TimeOfDay selectedTime) {
    DateTime now = DateTime.now();
    DateTime selectedDateTime = DateTime(
      newStartDate!.year,
      newStartDate!.month,
      newStartDate!.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    return selectedDateTime.isAfter(now);
  }
}
