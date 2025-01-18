import 'package:flutter/material.dart';
import '../models/restaurant.dart';

class BookmarkPage extends StatefulWidget {
  static List<Restaurant> bookmarkedRestaurants = [];

  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "No bookmarks yet.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
