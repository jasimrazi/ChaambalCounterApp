import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chaambal_counter/model/model.dart';

class DetailsPage extends StatefulWidget {
  final String name;
  final List<Chaambal> entries;

  const DetailsPage({
    Key? key,
    required this.name,
    required this.entries,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Future<void> deleteEntry(Chaambal entry) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chaambalsStrings = prefs.getStringList('chaambals');
    if (chaambalsStrings != null) {
      chaambalsStrings.removeWhere((jsonString) {
        Map<String, dynamic> json =
            Map<String, dynamic>.from(jsonDecode(jsonString));
        Chaambal chaambal = Chaambal.fromJson(json);
        return chaambal.name == entry.name &&
            chaambal.date == entry.date &&
            chaambal.time == entry.time;
      });
      await prefs.setStringList('chaambals', chaambalsStrings);
      setState(() {
        widget.entries.remove(entry);
      });
    }
  }

  Future<void> deleteAllEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chaambalsStrings = prefs.getStringList('chaambals');
    if (chaambalsStrings != null) {
      chaambalsStrings.removeWhere((jsonString) {
        Map<String, dynamic> json =
            Map<String, dynamic>.from(jsonDecode(jsonString));
        Chaambal chaambal = Chaambal.fromJson(json);
        return chaambal.name == widget.name;
      });
      await prefs.setStringList('chaambals', chaambalsStrings);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: widget.entries.isNotEmpty &&
                      widget.entries.first.image != null
                  ? FileImage(widget.entries.first.image!)
                  : null,
              child:
                  widget.entries.isEmpty || widget.entries.first.image == null
                      ? Icon(Icons.person)
                      : null,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              widget.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: widget.entries.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.entries.length) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await deleteAllEntries();
                      },
                      child: Text('Clear All Entries'),
                    ),
                  );
                }

                Chaambal entry = widget.entries[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  elevation: 3,
                  child: ListTile(
                    title: Text('Reason: ${entry.reason}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(entry.date))}',
                        ),
                        Text(
                          'Time: ${entry.time}',
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await deleteEntry(entry);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
