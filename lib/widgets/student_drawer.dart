// ✅ student_drawer.dart
import 'package:flutter/material.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo.shade400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  'Ashwin Daniel',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'Student',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.dashboard,
            label: 'Dashboard',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/student_dashboard');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.class_,
            label: 'My Classes',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/classes');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.assignment,
            label: 'Assignments',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/assignments');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            label: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            label: 'Logout',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(label),
      onTap: onTap,
    );
  }
}