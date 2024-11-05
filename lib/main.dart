import 'package:flutter/material.dart';
import 'package:item_tracker/ViewModel/get_tasks.dart';
import 'package:provider/provider.dart';

import 'View/tasks_list_ui.dart';


void main() {
  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child:  const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Item Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const ItemTrackerApp(),
    );
  }
}

