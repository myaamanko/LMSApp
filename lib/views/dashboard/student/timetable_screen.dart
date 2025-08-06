import 'package:flutter/material.dart';

import '../../../widgets/student_drawer.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  int selectedDayIndex = 0;

  final List<String> days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  final List<String> dates = ['12', '13', '14', '15', '16', '17'];

  final Map<int, List<Map<String, String>>> weeklySchedule = {
    0: [
      {'subject': 'Tamil', 'time': '9.00AM - 9.45AM'},
      {'subject': 'English', 'time': '9.45AM - 10.30AM'},
      {'subject': 'Break', 'time': '10.30AM - 10.45AM'},
      {'subject': 'Math', 'time': '10.45AM - 11.30AM'},
      {'subject': 'Chem', 'time': '11.30AM - 12.15PM'},
      {'subject': 'Lunch', 'time': '12.15PM - 1.00PM'},
      {'subject': 'Bio', 'time': '1.00PM - 1.45PM'},
      {'subject': 'History', 'time': '1.45PM - 2.15PM'},
      {'subject': 'Break', 'time': '2.15PM - 2.30PM'},
      {'subject': 'Tamil', 'time': '2.30PM - 3.15PM'},
      {'subject': 'Play Time', 'time': '3.15PM - 4.00PM'},
    ],
    1: [
      {'subject': 'English', 'time': '9.00AM - 9.45AM'},
      {'subject': 'History', 'time': '9.45AM - 10.30AM'},
      {'subject': 'Break', 'time': '10.30AM - 10.45AM'},
      {'subject': 'Math', 'time': '10.45AM - 11.30AM'},
      {'subject': 'Chem', 'time': '11.30AM - 12.15PM'},
      {'subject': 'Lunch', 'time': '12.15PM - 1.00PM'},
      {'subject': 'Geo', 'time': '1.00PM - 1.45PM'},
      {'subject': 'PE', 'time': '1.45PM - 2.15PM'},
      {'subject': 'Break', 'time': '2.15PM - 2.30PM'},
      {'subject': 'Tamil', 'time': '2.30PM - 3.15PM'},
      {'subject': 'Drawing', 'time': '3.15PM - 4.00PM'},
    ],
    // Add more day-wise schedules here if needed
  };
  @override
  Widget build(BuildContext context) {
    final schedule = weeklySchedule[selectedDayIndex] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
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
        title: const Text('Time Table', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Image.asset('assets/images/Profile.png', height: 60),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const StudentDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 20,),
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedDayIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedDayIndex = index),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              days[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dates[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.blue : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: schedule.length,
                itemBuilder: (context, index) {
                  final subject = schedule[index]['subject']!;
                  final time = schedule[index]['time']!;
                  final isBreak = subject.toLowerCase() == 'break';
                  final isLunch = subject.toLowerCase() == 'lunch';
                  // final item = schedule[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: isBreak
                          ? Colors.yellow.shade50
                          : isLunch
                          ? Colors.green.shade50
                          : Colors.grey.shade100,

                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text(time, style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
