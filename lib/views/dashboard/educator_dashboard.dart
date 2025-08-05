import 'package:flutter/material.dart';

class EducatorDashboard extends StatelessWidget {
  const EducatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final spacing = size.height * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Educator Dashboard'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Educator 👩‍🏫',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Manage your courses, assignments, and student feedback.', style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: spacing),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                children: [
                  _buildCard(context, 'Create Assignment', Icons.create, Colors.deepPurple, () {}),
                  _buildCard(context, 'View Submissions', Icons.fact_check, Colors.green, () {}),
                  _buildCard(context, 'Messages', Icons.message, Colors.teal, () {}),
                  _buildCard(context, 'Gradebook', Icons.grade, Colors.orange, () {}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
