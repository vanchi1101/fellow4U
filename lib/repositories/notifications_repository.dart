class NotificationsRepository {
  const NotificationsRepository();

  List<Map<String, dynamic>> getAllNotifications() {
    return const [
      {
        'title':
            'Tuan Tran accepted your request for the trip in Danang, Vietnam on Jan 20, 2020',
        'daySent': '2026-04-15T07:55:00.000',
        'avatarImage': 'assets/explore/guide1.png',
        'actionIcon': 'location',
      },
      {
        'title':
            'Emmy sent you an offer for the trip in Ho Chi Minh, Vietnam on Feb 12, 2020',
        'daySent': '2026-04-15T07:00:00.000',
        'avatarImage': 'assets/explore/guide2.png',
        'actionIcon': 'notes',
      },
      {
        'title': 'New Message from Lionel Messi',
        'daySent': '2026-04-15T06:00:00.000',
        'avatarImage': 'assets/explore/guide3.png',
        'actionIcon': 'edit',
      },
    ];
  }
}
