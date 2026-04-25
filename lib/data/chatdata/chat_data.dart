import 'package:sign_up_in/models/chat_model.dart';

final List<ChatUser> chatUsers = [
  ChatUser(
    name: "Donald Trump",
    lastMessage: "Hey, how are you?",
    time: "2:30 PM",
    avatarImage: "assets/explore/guide1.png",
  ),
  ChatUser(
    name: "Kylian Mbappe",
    lastMessage: "See you tomorrow!",
    time: "1:45 PM",
    avatarImage: "assets/explore/guide2.png",
  ),
  ChatUser(
    name: "Lionl Messi",
    lastMessage: "See you tomorrow!",
    time: "1:45 PM",
    avatarImage: "assets/explore/guide3.png",
  ),
  // Add more chat users as needed
];

final List<ChatDetail> chatDetails = [
  ChatDetail(name: "Donald Trump", avatarImage: "assets/explore/guide1.png"),
  ChatDetail(name: "Kylian Mbappe", avatarImage: "assets/explore/guide2.png"),
  ChatDetail(name: "Lionl Messi", avatarImage: "assets/explore/guide3.png"),
  // Add more chat details as needed
];

final List<ChatMessage> chatMessages = [
  ChatMessage(text: "hi, this is Donald Trump", isMe: false, time: "10:30 AM"),
  ChatMessage(
    text:
        "It is a long established fact that a reader will be distracted by the",
    isMe: true,
    time: "10:30 AM",
  ),
  ChatMessage(
    text: "as opposed to using 'Content here'",
    isMe: false,
    time: "10:31 AM",
  ),
  ChatMessage(
    text: "There are many variations of passages",
    isMe: false,
    time: "10:31 AM",
  ),
];
