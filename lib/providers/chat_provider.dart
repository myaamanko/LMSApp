import 'package:flutter/foundation.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  final List<Message> _messages = [
    Message(text: "Hi, Mandy", timestamp: DateTime.now(), sender: Sender.user),
    Message(text: "I’ve tried the app", timestamp: DateTime.now(), sender: Sender.user),
    Message(text: "Really?", timestamp: DateTime.now(), sender: Sender.other),
    Message(text: "Yeah, It’s really good!", timestamp: DateTime.now(), sender: Sender.user),
  ];

  List<Message> get messages => _messages;

  bool _isTyping = true;

  bool get isTyping => _isTyping;

  void sendMessage(String text) {
    _messages.add(
      Message(
        text: text,
        timestamp: DateTime.now(),
        sender: Sender.user,
      ),
    );
    _isTyping = false;
    notifyListeners();
  }

  void receiveMessage(String text) {
    _messages.add(
      Message(
        text: text,
        timestamp: DateTime.now(),
        sender: Sender.other,
      ),
    );
    notifyListeners();
  }

  void setTyping(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }
}
