import 'package:flutter/material.dart';
import 'package:lsm/models/message.dart';


class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == Sender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser)
              const CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage('assets/images/avatar_female.png'),
              ),
            const SizedBox(width: 6),
            Flexible(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isUser ? Colors.blue : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            if (isUser)
              const CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage('assets/images/avatar_male.png'),
              ),
          ],
        ),
      ),
    );
  }
}
