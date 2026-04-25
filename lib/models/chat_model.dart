class ChatUser {
  final String name;
  final String lastMessage;
  final String time;
  final String avatarImage;

  ChatUser({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarImage,
  });
}

class ChatDetail {
  final String name;
  final String avatarImage;

  ChatDetail({required this.name, required this.avatarImage});
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}
