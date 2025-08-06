import 'package:flutter/material.dart';

import '../models/teacher_model.dart';

class TeacherCard extends StatelessWidget {
  final Teacher teacher;

  const TeacherCard({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(teacher.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(12),
      child: Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(teacher.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(teacher.subject, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
