import 'package:flutter/material.dart';
import '../widgets/student_drawer.dart';
import 'customize_payment_screen.dart';
import '../widgets/fee_card.dart';
import '../widgets/additional_payment_card.dart';


class FeeScreen extends StatelessWidget {
  const FeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Fees', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FeeCard(
                  title: "Tuition",
                  total: 80000,
                  paid: 50000,
                  pending: 30000,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CustomizePaymentScreen()),
                    );
                  },
                ),
                FeeCard(
                  title: "Hostel",
                  total: 60000,
                  paid: 40000,
                  pending: 20000,
                  onTap: () {},
                ),
                FeeCard(
                  title: "Transport",
                  total: 0,
                  paid: 0,
                  pending: 0,
                  onTap: () {},
                  disabled: true,
                ),
                FeeCard(
                  title: "Day-scholar",
                  total: 0,
                  paid: 0,
                  pending: 0,
                  onTap: () {},
                  disabled: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Additional payments", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            AdditionalPaymentCard(
              title: "Annual Day 2025 Fees",
              description: "A mandatory fee collected from all students to cover expenses for the Annual Day celebrations in 2025.",
              amount: 2000,
              dueDate: "22 Jan",
            ),
            const SizedBox(height: 12),
            AdditionalPaymentCard(
              title: "Summer Trip Fees",
              description: "fee for transportation, accommodation, and activities for the upcoming summer trip.",
              amount: 1000,
              dueDate: "27 Jan",
            ),
          ],
        ),
      ),
    );
  }
}
