import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    final cardHeight = size.height * 0.18;
    final spacing = size.height * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${auth.role == 'lecturer' ? 'Educator' : 'Student'}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Here’s your quick overview:',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: spacing),

            // Card Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                children: [
                  _buildDashboardCard(
                    context,
                    title: 'Assignments',
                    icon: Icons.assignment,
                    color: Colors.deepPurple,
                    onTap: () {
                      // TODO: Navigate to assignments
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Messages',
                    icon: Icons.chat,
                    color: Colors.teal,
                    onTap: () {
                      // TODO: Navigate to chat
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Grades',
                    icon: Icons.grade,
                    color: Colors.orange,
                    onTap: () {
                      // TODO: Navigate to grades
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Courses',
                    icon: Icons.school,
                    color: Colors.blueGrey,
                    onTap: () {
                      // TODO: Navigate to courses
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
