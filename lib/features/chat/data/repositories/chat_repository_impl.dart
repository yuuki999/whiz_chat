import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final SupabaseClient _supabaseClient;

  ChatRepositoryImpl(this._supabaseClient);

  @override
  Stream<List<Message>> getMessages() {
    print('getMessages called');
    return _supabaseClient
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((List<Map<String, dynamic>> data) {
      print('Received data: $data');
      return data.map((json) {
        // Supabaseから返されるタイムスタンプをDateTimeに変換
        if (json['created_at'] is String) {
          json['created_at'] = DateTime.parse(json['created_at']);
        }
        return Message.fromJson(json);
      }).toList();
    });
  }

  @override
  Future<void> sendMessage(String content) async {
    print('Attempting to send message: $content');
    try {
      await _supabaseClient.from('messages').insert({
        'content': content,
        'user_id': "123e4567-e89b-12d3-a456-426614174000", // 仮のUUID
      });
      print('Message sent successfully');
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}