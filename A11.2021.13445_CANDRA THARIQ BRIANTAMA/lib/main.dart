import 'package:flutter/material.dart';
import 'package:food_finder/pages/login_page.dart';
import 'package:food_finder/pages/main_page.dart';
import 'package:food_finder/pages/profile_resto_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Finder',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/main': (context) => const MainPage(),
        '/profile_restaurant': (context) => ProfileRestaurantPage(),
        '/no_resto': (context) => const NoRestoPage(),
      },
    );
  }
}
