import 'package:sign_up_in/repositories/chat_repository.dart';

class ChatController {
  ChatController({ChatRepository? repository})
    : _repository = repository ?? const ChatRepository();

  final ChatRepository _repository;

  Map<String, dynamic> getAllChat() {
    final users = _repository.getAllChatUsers();

    return {'users': users};
  }

  List<Map<String, dynamic>> getChatUsers() => _repository.getAllChatUsers();
}
