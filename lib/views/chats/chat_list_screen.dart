import 'package:flutter/material.dart';
import '../../widgets/student_drawer.dart';
import 'chat_body.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

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
        title: const Text('Chats', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Image.asset('assets/images/Profile.png', height: 60),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const StudentDrawer(),
      body: const ChatBody(),
    );
  }
}
