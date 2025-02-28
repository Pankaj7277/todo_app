import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_demo/todo_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.amber,
          appBarTheme: AppBarTheme(
            color: Colors.amber[200],
          ),
        dialogTheme: const DialogTheme(
          shadowColor: Colors.amber,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
        )
      ),
      home: const ToDoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
