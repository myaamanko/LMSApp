enum Sender { user, other }

class Message {
  final String text;
  final DateTime timestamp;
  final Sender sender;

  Message({
    required this.text,
    required this.timestamp,
    required this.sender,
  });
}
