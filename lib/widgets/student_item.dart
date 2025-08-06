import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentItem extends StatelessWidget {
  final Student student;

  const StudentItem({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(student.imageUrl)),
      title: Text(student.name),
      trailing: const Icon(Icons.more_vert),
    );
  }
}
