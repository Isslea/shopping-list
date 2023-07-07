import 'package:flutter/material.dart';

import 'package:lol/widgets/item_list.dart';
import 'package:lol/widgets/shopping_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white38, // Set the app bar background color
          foregroundColor: Colors.black, // Set the app bar text color
        ),
      ),
      initialRoute: '/',
      routes: {
      '/': (ctx) => const ShoppingList()
      },
    );
  }
}