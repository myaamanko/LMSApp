import 'package:flutter/material.dart';

class FeeCard extends StatelessWidget {
  final String title;
  final int total;
  final int paid;
  final int pending;
  final bool disabled;
  final VoidCallback onTap;

  const FeeCard({
    super.key,
    required this.title,
    required this.total,
    required this.paid,
    required this.pending,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 24,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Text("₹${total.toString()}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            if (!disabled) ...[
              const SizedBox(height: 4),
              Text("₹${paid.toString()} paid", style: const TextStyle(color: Colors.green)),
              Text("₹${pending.toString()} pending", style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: onTap, child: const Text("Pay")),
            ],
          ],
        ),
      ),
    );
  }
}
