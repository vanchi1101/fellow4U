import 'package:sign_up_in/repositories/notifications_repository.dart';

class NotificationsController {
  NotificationsController({NotificationsRepository? repository})
    : _repository = repository ?? const NotificationsRepository();

  final NotificationsRepository _repository;

  Map<String, dynamic> getAllNotifications() {
    final notifications = _repository.getAllNotifications();
    return {'notifications': notifications};
  }

  List<Map<String, dynamic>> getNotifications() =>
      _repository.getAllNotifications();
}
