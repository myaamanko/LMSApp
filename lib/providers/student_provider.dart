import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentProvider with ChangeNotifier {
  final List<Student> _students = [
    Student(name: 'Darrell Steward', imageUrl: 'assets/avatars/avatar1.png'),
    Student(name: 'Victoria Hanson', imageUrl: 'assets/avatars/avatar2.png'),
    Student(name: 'Robert Fox', imageUrl: 'assets/avatars/avatar3.png'),
    Student(name: 'Cody Fisher', imageUrl: 'assets/avatars/avatar4.png'),
    Student(name: 'Albert Flores', imageUrl: 'assets/avatars/avatar5.png'),
    Student(name: 'Theresa Webb', imageUrl: 'assets/avatars/avatar6.png'),
    Student(name: 'Ralph Edwards', imageUrl: 'assets/avatars/avatar7.png'),
    Student(name: 'Ronald Richards', imageUrl: 'assets/avatars/avatar8.png'),
    Student(name: 'Cameron Williamson', imageUrl: 'assets/avatars/avatar9.png'),
    Student(name: 'Kathryn Murphy', imageUrl: 'assets/avatars/avatar10.png'),
    Student(name: 'Floyd Miles', imageUrl: 'assets/avatars/avatar11.png'),
    Student(name: 'Eleanor Pena', imageUrl: 'assets/avatars/avatar12.png'),
    Student(name: 'Annette Black', imageUrl: 'assets/avatars/avatar13.png'),
  ];

  List<Student> get students => [..._students];
}
