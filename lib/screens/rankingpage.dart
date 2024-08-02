import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chaambal_counter/model/model.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key, required this.chaambals}) : super(key: key);

  final List<Chaambal> chaambals;

  @override
  Widget build(BuildContext context) {
    List<Chaambal> top3Chaambals = _getTop3Chaambals();

    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking Page'),
      ),
      body: ListView.builder(
        itemCount: top3Chaambals.length,
        itemBuilder: (context, index) {
          Chaambal chaambal = top3Chaambals[index];
          String subtitle;
          switch (index) {
            case 0:
              subtitle = 'First Place';
              break;
            case 1:
              subtitle = 'Second Place';
              break;
            case 2:
              subtitle = 'Third Place';
              break;
            default:
              subtitle = '';
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  chaambal.image != null ? FileImage(chaambal.image!) : null,
              child: chaambal.image == null ? Icon(Icons.person) : null,
            ),
            title: Text(
              chaambal.name,
              style: TextStyle(fontSize: 16),
            ),
            subtitle: Text(subtitle),
            trailing: index == 0
                ? Icon(Icons.emoji_events, color: Colors.yellow)
                : null,
          );
        },
      ),
    );
  }

  List<Chaambal> _getTop3Chaambals() {
    // Create a map to aggregate counts by name
    Map<String, Chaambal> aggregatedChaambals = {};

    for (var chaambal in chaambals) {
      if (aggregatedChaambals.containsKey(chaambal.name)) {
        aggregatedChaambals[chaambal.name]!.count += chaambal.count;
      } else {
        aggregatedChaambals[chaambal.name] = Chaambal(
          name: chaambal.name,
          reason: chaambal.reason,
          date: chaambal.date,
          time: chaambal.time,
          image: chaambal.image,
          count: chaambal.count,
        );
      }
    }

    // Convert map to list and sort by count in descending order
    List<Chaambal> sortedChaambals = aggregatedChaambals.values.toList();
    sortedChaambals.sort((a, b) => b.count.compareTo(a.count));

    // Return top 3 chaambals
    return sortedChaambals.length > 3
        ? sortedChaambals.sublist(0, 3)
        : sortedChaambals;
  }
}
