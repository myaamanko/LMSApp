import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../widgets/student_drawer.dart';
import 'package:fl_chart/fl_chart.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    final userDocStream =
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: userDocStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text('Profile not found')));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final name = data['name'] ?? 'Student';
        final imageUrl = data['imageUrl'] ?? '';
        final attendance = data['attendance'] ?? 0;
        final taskCompleted = data['taskCompleted'] ?? 0;
        final taskInProgress = data['taskInProgress'] ?? 0;
        final rewardPoints = data['rewardPoints'] ?? 0;

        return Scaffold(
          appBar: AppBar(
            title: Text('Dashboard'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.black),
              ),
              const SizedBox(width: 16),
            ],
          ),

          drawer: const StudentDrawer(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildWelcomeCard(name),
                const SizedBox(height: 20),
                _buildStatGrid(
                  attendance,
                  taskCompleted,
                  taskInProgress,
                  rewardPoints,
                ),
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
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            selectedItemColor: Colors.indigo,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: '',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
            ],
          ),
        );
      },
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.notifications_none),
      ],
    );
  }

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
                Text(
                  'Hey $name.',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Welcome back! Let's dive into your classes and keep moving toward your goals.",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/welcome_illustration.png', height: 60),
        ],
      ),
    );
  }

  Widget _buildStatGrid(
    int attendance,
    int taskCompleted,
    int taskInProgress,
    int rewardPoints,
  ) {
    final stats = [
      {'title': '$attendance%', 'label': 'Attendance','icon':'assets/images/people.png'},
      {'title': '$taskCompleted+', 'label': 'Task Completed','icon':'assets/images/task.png'},
      {'title': '$taskInProgress%', 'label': 'Task in Progress','icon':'assets/images/progress.png'},
      {'title': '$rewardPoints', 'label': 'Reward Points','icon':'assets/images/award.png'},
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
              Row(
                children: [Image.asset(stats[index]['icon']!),
                const SizedBox(width: 4),
                  Text(
                    stats[index]['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                stats[index]['label']!,
                style: const TextStyle(color: Colors.black54),
              ),
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Notice Board',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('view all', style: TextStyle(color: Colors.indigo)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/notice1.png'),
                ),
                title: Text(
                  "The school's Annual Sports Day will be held on May 12, 2024.",
                ),
                subtitle: Text('1h ago · by Principal'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/notice2.png'),
                ),
                title: Text("Summer Holiday begins on May-25, 2024."),
                subtitle: Text('3h ago · by Principal'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildTestScoreActivity() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: const Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Test Score activity',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(height: 16),
  //         Placeholder(fallbackHeight: 100),
  //       ],
  //     ),
  //   );
  // }
  

  Widget _buildTestScoreActivity() {
    final testScores = [
      FlSpot(0, 60),
      FlSpot(1, 75),
      FlSpot(2, 65),
      FlSpot(3, 80),
      FlSpot(4, 70),
      FlSpot(5, 90),
      FlSpot(6, 60),
    ];

    final dateLabels = ['Apr10', 'Apr11', 'Apr12', 'Apr13', 'Apr14', 'Apr15', 'Apr16'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Test Score activity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              CircleAvatar(
                backgroundColor: Color(0xFFF1ECFC),
                radius: 16,
                child: Icon(Icons.settings, color: Color(0xFF7A50C4), size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: testScores.length - 1,
                minY: 0,
                maxY: 100,
                backgroundColor: Colors.transparent,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.grey.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, _) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            dateLabels[value.toInt()],
                            style: const TextStyle(fontSize: 12, color: Colors.black45),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: testScores,
                    isCurved: true,
                    color: const Color(0xFFFFCD4D),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFFFCD4D).withOpacity(0.2),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                        radius: 4,
                        color: const Color(0xFFFFCD4D),
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.white,
                   
                    getTooltipItems: (spots) => spots.map((spot) {
                      return LineTooltipItem(
                        '${spot.y.toInt()}%',
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildResources() {
    final items = [
      {'title': 'Books', 'icon':'assets/images/books.png', 'color': Colors.pink.shade50},
      {
        'title': 'Videos',
        'icon': 'assets/images/videos.png',
        'color': Colors.green.shade50,
      },
      {
        'title': 'Papers',
        'icon': 'assets/images/papers.png',
        'color': Colors.purple.shade50,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Resources',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('view all', style: TextStyle(color: Colors.indigo)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              items.map((item) {
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
                        Image.asset(item['icon'] as String, height: 60),

                        const SizedBox(height: 8),
                        Text(
                          item['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
