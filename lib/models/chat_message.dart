class ChatMessage {
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isSender;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.isSender,
  });
}
