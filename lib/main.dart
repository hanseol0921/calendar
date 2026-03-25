import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:practice/pages/calendar_page.dart';

void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalenadrPage(),
    );
  }
}

