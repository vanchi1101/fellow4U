import 'package:flutter/material.dart';

enum NotificationActionIcon { location, notes, edit }

extension NotificationActionIconX on NotificationActionIcon {
  IconData get iconData {
    switch (this) {
      case NotificationActionIcon.location:
        return Icons.location_on_rounded;
      case NotificationActionIcon.notes:
        return Icons.sticky_note_2_rounded;
      case NotificationActionIcon.edit:
        return Icons.edit_rounded;
    }
  }
}

class Notification {
  final String title;
  final DateTime daySent;
  final String avatarImage;
  final NotificationActionIcon actionIcon;

  Notification({
    required this.title,

    required this.daySent,
    required this.avatarImage,
    required this.actionIcon,
  });
}
