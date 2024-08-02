import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TextFieldType { text, date, time, multiline }

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final TextFieldType fieldType;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.controller,
    this.fieldType = TextFieldType.text,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Future<void> _selectDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      widget.controller?.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final DateTime now = DateTime.now();
      final DateTime selectedTime =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);
      widget.controller?.text = DateFormat('HH:mm').format(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            readOnly: widget.readOnly,
            maxLines: widget.fieldType == TextFieldType.multiline ? null : 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 14.0,
              ),
              suffixIcon: widget.fieldType == TextFieldType.date &&
                      !widget.readOnly
                  ? GestureDetector(
                      onTap: widget.onTap,
                      child: Icon(Icons.calendar_today),
                    )
                  : widget.fieldType == TextFieldType.time && !widget.readOnly
                      ? GestureDetector(
                          onTap: widget.onTap,
                          child: Icon(Icons.access_time),
                        )
                      : null,
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            onTap: widget.onTap,
          ),
        ],
      ),
    );
  }
}
