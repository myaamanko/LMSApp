import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat_message.dart';
import '../../providers/chat_provider.dart';


class ChatDetailBody extends StatefulWidget {
  const ChatDetailBody({super.key});

  @override
  State<ChatDetailBody> createState() => _ChatDetailBodyState();
}

class _ChatDetailBodyState extends State<ChatDetailBody> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false).sendMessage(text);
      _controller.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Column(
      children: [
        // Chat list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: chatProvider.messages.length + (chatProvider.isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == chatProvider.messages.length && chatProvider.isTyping) {
                return _buildTypingIndicator();
              }

              final ChatMessage msg = chatProvider.messages[index];
              return msg.isSender
                  ? _buildSenderBubble(msg.message)
                  : _buildReceiverBubble(msg.message);
            },
          ),
        ),

        // Input box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (text) {
                    Provider.of<ChatProvider>(context, listen: false)
                        .setTyping(text.isNotEmpty);
                  },
                  decoration: InputDecoration(
                    hintText: "Type your message",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sendMessage,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.send, color: Colors.white, size: 18),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSenderBubble(String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 6),
        const CircleAvatar(
          radius: 12,
          backgroundImage: AssetImage('assets/user_avatar.png'), // current user
        ),
      ],
    );
  }

  Widget _buildReceiverBubble(String message) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 12,
          backgroundImage: AssetImage('assets/avatar1.png'), // other user
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(message, style: const TextStyle(color: Colors.black87)),
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 12,
          backgroundImage: AssetImage('assets/avatar1.png'),
        ),
        const SizedBox(width: 6),
        Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('Typing...', style: TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }
}
