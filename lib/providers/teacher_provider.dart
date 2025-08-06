import 'package:flutter/material.dart';

import '../models/teacher_model.dart';

class TeacherProvider with ChangeNotifier {
  TeacherType _filter = TeacherType.All;

  TeacherType get filter => _filter;

  void setFilter(TeacherType newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  final List<Teacher> _allTeachers = [
    Teacher(name: 'Robert Fox', subject: 'Biology Teacher', imageUrl: 'assets/images/teachers1.png', type: TeacherType.Teaching),
    Teacher(name: 'Devon Lane', subject: 'Math Teacher', imageUrl: 'assets/images/teachers2.png', type: TeacherType.Teaching),
    Teacher(name: 'Annette Black', subject: 'Accountant', imageUrl: 'assets/images/teachers3.png', type: TeacherType.NonTeaching),
    Teacher(name: 'Ralph Edwards', subject: 'Tamil Teacher', imageUrl: 'assets/images/teachers4.png', type: TeacherType.Teaching),
    Teacher(name: 'Guy Hawkins', subject: 'Chemistry Teacher', imageUrl: 'assets/images/teachers5.png', type: TeacherType.Teaching),
    Teacher(name: 'Wade Warren', subject: 'English Teacher', imageUrl:'assets/images/teachers6.png', type: TeacherType.Teaching),
    Teacher(name: 'Jenny Wilson', subject: 'Accountant', imageUrl: 'assets/images/teachers7.png', type: TeacherType.NonTeaching),
    Teacher(name: 'Jacob Jones', subject: 'History Teacher', imageUrl:'assets/images/teachers8.png', type: TeacherType.Teaching),
  ];

  List<Teacher> get filteredTeachers {
    if (_filter == TeacherType.All) return _allTeachers;
    return _allTeachers.where((t) => t.type == _filter).toList();
  }
}
