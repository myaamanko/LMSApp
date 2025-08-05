import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage('assets/images/avatar_female.png'),
          ),
          SizedBox(width: 6),
          Text(
            "Typing...",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
