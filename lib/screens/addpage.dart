import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chaambal_counter/model/model.dart';
import 'package:chaambal_counter/widgets/textfield.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    // Set the default date and time to current date and time
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    timeController.text = DateFormat('HH:mm').format(DateTime.now());
  }

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  String toCamelCase(String str) {
    return str.split(' ').map((word) {
      return word.isEmpty
          ? ''
          : word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void _submitChaambal() async {
    if (nameController.text.isNotEmpty &&
        reasonController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty) {
      // Convert the name to camel case
      String camelCaseName = toCamelCase(nameController.text);

      // Create a new Chaambal object
      Chaambal newChaambal = Chaambal(
        name: camelCaseName,
        reason: reasonController.text,
        date: dateController.text,
        time: timeController.text,
        image: _image,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> chaambalsStrings =
          prefs.getStringList('chaambals') ?? []; // Get existing chaambals

      // Convert Chaambal object to JSON and add to the list
      chaambalsStrings.add(jsonEncode(newChaambal.toJson()));

      // Save the updated list back to SharedPreferences
      await prefs.setStringList('chaambals', chaambalsStrings);

      // Clear fields after submission
      nameController.clear();
      reasonController.clear();
      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      timeController.text = DateFormat('HH:mm').format(DateTime.now());
      setState(() {
        _image = null;
      });

      // Send result back to Homepage
      Navigator.pop(context, true); // Or any data you want to pass back
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Chaambal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              GestureDetector(
                onTap: _selectImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child:
                      _image == null ? Icon(Icons.add_a_photo, size: 40) : null,
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                labelText: 'Name',
                fieldType: TextFieldType.text,
              ),
              CustomTextField(
                controller: dateController,
                labelText: 'Date',
                fieldType: TextFieldType.date,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              CustomTextField(
                controller: timeController,
                labelText: 'Time',
                fieldType: TextFieldType.time,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      timeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
              CustomTextField(
                controller: reasonController,
                labelText: 'Reason',
                fieldType: TextFieldType.multiline,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitChaambal,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
