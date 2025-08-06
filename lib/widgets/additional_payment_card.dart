import 'package:flutter/material.dart';

class AdditionalPaymentCard extends StatelessWidget {
  final String title;
  final String description;
  final int amount;
  final String dueDate;

  const AdditionalPaymentCard({
    super.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Due: $dueDate", style: const TextStyle(color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 6),
            Text(description, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₹$amount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(onPressed: () {}, child: const Text("Pay")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
