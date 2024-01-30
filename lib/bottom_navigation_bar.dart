import 'package:flutter/material.dart';
import 'package:test_task/task_one/objects_screen.dart';
import 'package:test_task/task_two/movies_list_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() =>
      _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState
    extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;
  static  final List<Widget> _widgetOptions = <Widget>[
    const ObjectsScreen(),
    const MoviesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'TASK ONE',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_creation_outlined),
            label: 'TASK TWO',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo[300],
        onTap: _onItemTapped,
      ),
    );
  }
}