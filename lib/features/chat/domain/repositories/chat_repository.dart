import '../entities/message.dart';

abstract class ChatRepository {
  Stream<List<Message>> getMessages();
  Future<void> sendMessage(String content);
}