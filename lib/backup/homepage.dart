// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:chaambal_counter/model/model.dart';
// import 'package:chaambal_counter/screens/addpage.dart';
// import 'package:chaambal_counter/screens/detailspage.dart';
// import 'package:chaambal_counter/screens/rankingpage.dart';

// class Homepage extends StatefulWidget {
//   const Homepage({Key? key}) : super(key: key);

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   List<Chaambal> chaambals = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? chaambalsStrings = prefs.getStringList('chaambals');
//     if (chaambalsStrings != null) {
//       setState(() {
//         chaambals = chaambalsStrings
//             .map((jsonString) => Chaambal.fromJson(jsonDecode(jsonString)))
//             .toList();
//       });
//     }
//   }

//   Future<void> _saveData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> chaambalsStrings =
//         chaambals.map((chaambal) => jsonEncode(chaambal.toJson())).toList();
//     await prefs.setStringList('chaambals', chaambalsStrings);
//   }

//   void addChaambal(Chaambal newChaambal) {
//     setState(() {
//       // Check if the name already exists in the list
//       int existingIndex =
//           chaambals.indexWhere((c) => c.name == newChaambal.name);
//       if (existingIndex != -1) {
//         // Update the existing entry
//         chaambals[existingIndex].count++;
//       } else {
//         // Add the new entry
//         chaambals.add(newChaambal);
//       }
//     });

//     // Save the updated data
//     _saveData().then((_) {
//       // After saving, trigger a refresh
//       _loadData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Homepage'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: IconButton(
//               icon: Icon(
//                 Icons.emoji_events,
//                 color: Colors.deepPurple,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => RankingPage(
//                       chaambals: chaambals,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadData,
//         child: ListView.builder(
//           itemCount: chaambals.length,
//           itemBuilder: (context, index) {
//             Chaambal chaambal = chaambals[index];
//             DateTime latestDateTime;
//             try {
//               latestDateTime =
//                   DateTime.parse('${chaambal.date} ${chaambal.time}');
//             } catch (e) {
//               print('Error parsing date or time: $e');
//               latestDateTime = DateTime.now();
//             }

//             // Calculate total count for entries with the same name
//             int totalCount = chaambals
//                 .where((entry) => entry.name == chaambal.name)
//                 .fold<int>(0,
//                     (previousValue, element) => previousValue + element.count);

//             // Display only the first entry with the name and the total count
//             if (index == chaambals.indexWhere((c) => c.name == chaambal.name)) {
//               return Card(
//                 elevation: 3,
//                 margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 child: ListTile(
//                   title: Text(chaambal.name),
//                   subtitle: Text(
//                     'Latest Entry: ${DateFormat('dd-MMMM-yyyy hh:mm a').format(latestDateTime)}',
//                   ),
//                   trailing: CircleAvatar(
//                     backgroundColor: Colors.deepPurple.shade400,
//                     child: Text(
//                       '$totalCount',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   onTap: () async {
//                     List<Chaambal> filteredEntries = chaambals
//                         .where((entry) => entry.name == chaambal.name)
//                         .toList();
//                     bool? result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DetailsPage(
//                           name: chaambal.name,
//                           entries: filteredEntries,
//                         ),
//                       ),
//                     );
//                     if (result == true) {
//                       _loadData();
//                     }
//                   },
//                 ),
//               );
//             }

//             // Return an empty container for entries that are not the first with the name
//             return Container();
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddPage(),
//             ),
//           );

//           if (result != null && result is bool && result) {
//             _loadData(); // Reload data if result is true
//           }
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
