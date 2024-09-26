import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  final DateTime? firstDate;

  DatePickerField({
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime initialDate = selectedDate ?? now;
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: initialDate.isBefore(now) ? now : initialDate,
          firstDate: now,
          lastDate: DateTime(2100),
        );
        onDateSelected(date);
      },
      validator: (value) => selectedDate == null ? 'Select a date' : null,
      controller: TextEditingController(
        text: selectedDate != null
            ? selectedDate!.toLocal().toString().split(' ')[0]
            : '',
      ),
    );
  }
}
