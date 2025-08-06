import 'package:flutter/material.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with logo and title
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'LMSApp',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),

          // Menu title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Menu', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),

          // Menu items
          _buildDrawerItem(context, Icons.dashboard, 'Dashboard', '/student-dashboard'),
          _buildDrawerItem(context, Icons.person_outline, 'Teachers', '/teachers'),
          _buildDrawerItem(context, Icons.group_outlined, 'Students', '/students'),
          _buildDrawerItem(context, Icons.currency_rupee, 'Fees', '/fees'),
          _buildDrawerItem(context, Icons.calendar_today, 'Calendar', '/calendar'),
          _buildDrawerItem(context, Icons.schedule, 'Time Table', '/timetable'),
          _buildDrawerItem(context, Icons.message_outlined, 'Message', '/messages'),
          _buildDrawerItem(context, Icons.settings_outlined, 'Settings', '/settings'),

          const Spacer(),

          // Log out
          Center(
            child: TextButton(
              onPressed: () {
                // TODO: Implement logout logic
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Log out',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Helper method to build drawer list tiles
  Widget _buildDrawerItem(BuildContext context, IconData icon, String label, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
