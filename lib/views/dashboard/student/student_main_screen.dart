import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lsm/views/dashboard/student/student_dashboard.dart';
import 'package:lsm/views/dashboard/student/timetable_screen.dart';

class StudentMainScreen extends StatefulWidget {
  @override
  _StudentMainScreenState createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int _currentIndex = 0;

  final List<String> _titles = [
    'Dashboard',
    'Time Table',
    'Chat',
    'Profile',
  ];

  final List<Widget> _screens = [
    StudentDashboard(),
    TimeTableScreen(),
    Center(child: Text('Chat')), // Placeholder
    Center(child: Text('Profile')), // Placeholder
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.menu, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              _titles[_currentIndex],
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(backgroundImage: AssetImage('assets/avatar.png')),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}