import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fee_provider.dart';

class CustomizePaymentScreen extends StatelessWidget {
  const CustomizePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Customize Fee Payment")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Select a Payment Options", style: TextStyle(fontSize: 16)),
          ),
          RadioListTile(
            value: PaymentOption.full,
            groupValue: provider.selectedOption,
            onChanged: provider.setOption,
            title: const Text("Pay in Full"),
            subtitle: const Text("₹80,000"),
          ),
          RadioListTile(
            value: PaymentOption.half,
            groupValue: provider.selectedOption,
            onChanged: provider.setOption,
            title: const Text("Pay in Two Halves"),
            subtitle: const Text("₹40,000"),
          ),
          RadioListTile(
            value: PaymentOption.term,
            groupValue: provider.selectedOption,
            onChanged: provider.setOption,
            title: const Text("Pay in Terms"),
            subtitle: const Text("₹27,000"),
          ),
        ],
      ),
    );
  }
}
