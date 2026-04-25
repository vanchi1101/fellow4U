class ChatRepository {
  const ChatRepository();

  List<Map<String, dynamic>> getAllChatUsers() {
    return const [
      {
        'name': 'Donald Trump',
        'lastMessage': 'Hey, how are you?',
        'time': '2:30 PM',
        'avatarImage': 'assets/explore/guide1.png',
      },
      {
        'name': 'Kylian Mbappe',
        'lastMessage': 'See you tomorrow!',
        'time': '1:45 PM',
        'avatarImage': 'assets/explore/guide2.png',
      },
      {
        'name': 'Lionl Messi',
        'lastMessage': 'See you tomorrow!',
        'time': '1:45 PM',
        'avatarImage': 'assets/explore/guide3.png',
      },
    ];
  }
}
