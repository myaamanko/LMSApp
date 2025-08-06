import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔐 Get the current logged-in user (from student login)
    final currentUser = FirebaseAuth.instance.currentUser;

    // 🔒 Check if the user is logged in
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    // 🔄 Create a real-time stream from the student's Firestore document
    final userDocStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid) // 👉 uses the current student UID
        .snapshots(); // 👈 keeps listening for changes

    return StreamBuilder<DocumentSnapshot>(
      stream: userDocStream, // 👈 listening to this student's document
      builder: (context, snapshot) {
        // 🛡️ If data is not ready yet or missing, use empty map
        final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};

        // ✅ Extract student-specific fields with default values
        final name = data['name'] ?? 'Student';
        final attendance = data['attendance'] ?? 0;
        final taskCompleted = data['taskCompleted'] ?? 0;
        final taskInProgress = data['taskInProgress'] ?? 0;
        final rewardPoints = data['rewardPoints'] ?? 0;

        // 🧱 Full dashboard UI still builds even if data is missing
        return Scaffold(
          backgroundColor: const Color(0xFFF6F6FA),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
            title: const Text('Dashboard', style: TextStyle(color: Colors.black)),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.black),
              ),
              const SizedBox(width: 16),
            ],
          ),

          // 📦 Main scrollable content
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildWelcomeCard(name), // 👋 Pass student's name
                const SizedBox(height: 20),
                _buildStatGrid(attendance, taskCompleted, taskInProgress, rewardPoints),
                const SizedBox(height: 24),
                _buildNoticeBoard(),
                const SizedBox(height: 24),
                _buildTestScoreActivity(),
                const SizedBox(height: 24),
                _buildResources(),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // 📱 Bottom navigation
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            selectedItemColor: Colors.indigo,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
            ],
          ),
        );
      },
    );
  }

  // 🔍 UI for search bar
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.notifications_none)
      ],
    );
  }

  // 🙋 Welcome message using student name
  Widget _buildWelcomeCard(String name) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hey $name.',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text(
                    "Welcome back! Let's dive into your classes and keep moving toward your goals.",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          Image.asset('assets/images/welcome_illustration.png', height: 60),
        ],
      ),
    );
  }

  // 📊 Student stats grid (attendance, tasks, rewards)
  Widget _buildStatGrid(int attendance, int taskCompleted, int taskInProgress, int rewardPoints) {
    final stats = [
      {'title': '$attendance%', 'label': 'Attendance'},
      {'title': '$taskCompleted+', 'label': 'Task Completed'},
      {'title': '$taskInProgress%', 'label': 'Task in Progress'},
      {'title': '$rewardPoints', 'label': 'Reward Points'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: stats.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(stats[index]['title']!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(stats[index]['label']!,
                  style: const TextStyle(color: Colors.black54)),
            ],
          ),
        );
      },
    );
  }

  // 🗞️ Notices
  Widget _buildNoticeBoard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Notice Board', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('view all', style: TextStyle(color: Colors.indigo)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: const Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/notice1.png')),
                title: Text("The school's Annual Sports Day will be held on May 12, 2024."),
                subtitle: Text('1h ago · by Principal'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/notice2.png')),
                title: Text("Summer Holiday begins on May-25, 2024."),
                subtitle: Text('3h ago · by Principal'),
              )
            ],
          ),
        )
      ],
    );
  }

  // 📈 Placeholder for future chart integration
  Widget _buildTestScoreActivity() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Test Score activity',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Placeholder(fallbackHeight: 100)
        ],
      ),
    );
  }

  // 📚 Resources tiles
  Widget _buildResources() {
    final items = [
      {
        'title': 'Books',
        'icon': Icons.menu_book,
        'color': Colors.pink.shade50
      },
      {
        'title': 'Videos',
        'icon': Icons.play_circle_fill,
        'color': Colors.green.shade50
      },
      {
        'title': 'Papers',
        'icon': Icons.description,
        'color': Colors.purple.shade50
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Resources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('view all', style: TextStyle(color: Colors.indigo)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((item) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item['color'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(item['icon'] as IconData, size: 36),
                    const SizedBox(height: 8),
                    Text(item['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
