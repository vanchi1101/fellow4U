import 'package:sign_up_in/models/notification_model.dart';

final List<Notification> notifications = [
  Notification(
    title:
        "Tuan Tran accepted your request for the trip in Danang, Vietnam on Jan 20, 2020",
    daySent: DateTime.now().subtract(const Duration(minutes: 5)),
    avatarImage: "assets/explore/guide1.png",
    actionIcon: NotificationActionIcon.location,
  ),
  Notification(
    title:
        "Emmy sent you an offer for the trip in Ho Chi Minh, Vietnam on Feb 12, 2020",
    daySent: DateTime.now().subtract(const Duration(hours: 1)),
    avatarImage: "assets/explore/guide2.png",
    actionIcon: NotificationActionIcon.notes,
  ),
  Notification(
    title: "New Message from Lionel Messi",
    daySent: DateTime.now().subtract(const Duration(hours: 2)),
    avatarImage: "assets/explore/guide3.png",
    actionIcon: NotificationActionIcon.edit,
  ),
];
