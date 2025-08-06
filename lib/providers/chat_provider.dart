import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: "Me",
      message: "Hi, Mandy",
      timestamp: DateTime.now(),
      isSender: true,
    ),
    ChatMessage(
      sender: "Me",
      message: "I’ve tried the app",
      timestamp: DateTime.now(),
      isSender: true,
    ),
    ChatMessage(
      sender: "Maddy",
      message: "Really?",
      timestamp: DateTime.now(),
      isSender: false,
    ),
    ChatMessage(
      sender: "Me",
      message: "Yeah, It’s really good!",
      timestamp: DateTime.now(),
      isSender: true,
    ),
  ];

  bool _isTyping = true;

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  void sendMessage(String message) {
    _messages.add(ChatMessage(
      sender: "Me",
      message: message,
      timestamp: DateTime.now(),
      isSender: true,
    ));
    _isTyping = false;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _messages.add(ChatMessage(
        sender: "Maddy",
        message: "Nice! 😊",
        timestamp: DateTime.now(),
        isSender: false,
      ));
      notifyListeners();
    });
  }

  void setTyping(bool value) {
    _isTyping = value;
    notifyListeners();
  }
}
