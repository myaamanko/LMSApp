
import 'package:flutter/material.dart';

class EducatorDashboard extends StatelessWidget {
  const EducatorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
        centerTitle: false,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.person, color: Colors.black),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            _buildStatGrid(),
            const SizedBox(height: 24),
            _buildNoticeBoard(),
            const SizedBox(height: 24),
            _buildCourseActivity(),
            const SizedBox(height: 24),
            _buildResources(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }

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
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.notifications_none)
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello Educator 👩‍🏫', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text("Manage your classes, assignments, and feedback with ease.", style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          Image.asset('assets/images/welcome_illustration.png', height: 60) // placeholder
        ],
      ),
    );
  }

  Widget _buildStatGrid() {
    final stats = [
      {'title': '12', 'label': 'Courses'},
      {'title': '56', 'label': 'Assignments Given'},
      {'title': '32', 'label': 'Submissions Pending'},
      {'title': '120', 'label': 'Students Engaged'},
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
              Text(stats[index]['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(stats[index]['label']!, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoticeBoard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Notice Board', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('view all', style: TextStyle(color: Colors.deepPurple)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(backgroundImage: AssetImage('assets/images/notice1.png')),
                title: Text("Assignment reviews must be completed by May 10, 2024."),
                subtitle: Text('2h ago · System'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(backgroundImage: AssetImage('assets/images/notice2.png')),
                title: Text("End of term reports submission deadline: May 30, 2024."),
                subtitle: Text('5h ago · Principal'),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCourseActivity() {
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
          Text('Course Engagement Overview', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Placeholder(fallbackHeight: 100),
        ],
      ),
    );
  }

  Widget _buildResources() {
    final items = [
      {'title': 'Submissions', 'icon': Icons.upload_file, 'color': Colors.pink.shade50},
      {'title': 'Materials', 'icon': Icons.folder, 'color': Colors.green.shade50},
      {'title': 'Gradebook', 'icon': Icons.grade, 'color': Colors.purple.shade50},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Resources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('view all', style: TextStyle(color: Colors.deepPurple)),
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
                    Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
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
