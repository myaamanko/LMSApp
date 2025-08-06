import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/teacher_provider.dart';
import '../widgets/student_drawer.dart';
import '../widgets/teacher_card.dart';
import '../widgets/filter_chip_list.dart';

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teacherList = Provider.of<TeacherProvider>(context).filteredTeachers;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder:
              (context) => IconButton(
            icon: const Icon(Icons.menu, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Teachers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Image.asset('assets/images/Profile.png', height: 60),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const StudentDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            TextField(
              decoration: InputDecoration(
                hintText: "Search Teachers",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            // Filter chips
            const FilterChipList(),
            const SizedBox(height: 16),

            // Teachers Grid
            Expanded(
              child: GridView.builder(
                itemCount: teacherList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (ctx, i) => TeacherCard(teacher: teacherList[i]),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
