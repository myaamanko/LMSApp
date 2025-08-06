import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../widgets/student_drawer.dart';
import '../widgets/student_item.dart';
import '../widgets/search_bar.dart';


class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final students = Provider.of<StudentProvider>(context).students;

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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: CustomSearchBar(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Class 12',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (ctx, i) => StudentItem(student: students[i]),
            ),
          )
        ],
      ),

    );
  }
}
