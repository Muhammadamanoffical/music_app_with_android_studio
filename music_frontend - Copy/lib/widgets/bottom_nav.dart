import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int index;
  final Function(int) onChange;

  const BottomNav({super.key, required this.index, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onChange,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Liked"),
      ],
    );
  }
}