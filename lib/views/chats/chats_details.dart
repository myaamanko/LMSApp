import 'package:flutter/material.dart';
import 'chat_detail_body.dart';

class ChatDetailScreen extends StatelessWidget {
  final String name;
  final String avatar;

  const ChatDetailScreen({
    super.key,
    required this.name,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            CircleAvatar(
              backgroundImage: AssetImage(avatar),
              radius: 16,
            ),
          ],
        ),
        title: Text(name, style: const TextStyle(color: Colors.black)),
      ),
      body: const ChatDetailBody(),
    );
  }
}
