import 'package:flutter/material.dart';
import 'package:lsm/providers/chat_provider.dart';
import 'package:lsm/widgets/chat_bubble.dart';
import 'package:lsm/widgets/typing_indicator.dart';
import 'package:provider/provider.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar_male.png'),
            ),
            SizedBox(width: 12),
            Text("Maddy"),
          ],
        ),
        leading: const BackButton(),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: chatProvider.messages.length + (chatProvider.isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < chatProvider.messages.length) {
                  return ChatBubble(message: chatProvider.messages[index]);
                } else {
                  return const TypingIndicator();
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Type your message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      chatProvider.sendMessage(text);
                      controller.clear();
                      // Simulate reply
                      Future.delayed(const Duration(seconds: 2), () {
                        chatProvider.receiveMessage("Interesting!");
                        chatProvider.setTyping(true);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
