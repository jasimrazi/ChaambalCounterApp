import 'dart:io';

class Chaambal {
  String name;
  String reason;
  String date;
  String
      time; // Ensure this is stored as a String in a format DateTime can parse
  File? image;
  int count; // To store the count of entries for this name

  Chaambal({
    required this.name,
    required this.reason,
    required this.date,
    required this.time, // Initialize time in the constructor
    this.image,
    this.count = 1, // Initialize count to 1 for the first entry
  });

  // Method to convert a JSON string to a Chaambal object
  factory Chaambal.fromJson(Map<String, dynamic> json) {
    return Chaambal(
      name: json['name'],
      reason: json['reason'],
      date: json['date'],
      time: json['time'],
      image: json['image'] != null ? File(json['image']) : null,
      count: json['count'] ?? 1,
    );
  }

  // Method to convert a Chaambal object to a JSON string
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'reason': reason,
      'date': date,
      'time': time,
      'image': image?.path,
      'count': count,
    };
  }
}

List<Chaambal> chaambals = [];

void addChaambal({
  required String name,
  required String reason,
  required String date,
  required String time,
  File? image,
}) {
  chaambals.add(Chaambal(
    name: name,
    reason: reason,
    date: date,
    time: time,
    image: image,
  ));
}
