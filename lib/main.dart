import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chaambal_counter/screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPreferences(); // Initialize SharedPreferences
  runApp(const MyApp());
}

// Function to initialize SharedPreferences
Future<void> initSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // You can perform additional initialization here if needed
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffF8F9FA),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Homepage(),
    );
  }
}
