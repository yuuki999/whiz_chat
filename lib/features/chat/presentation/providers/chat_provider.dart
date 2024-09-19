import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final supabase = Supabase.instance.client;
  return ChatRepositoryImpl(supabase);
});

final messagesStreamProvider = StreamProvider<List<Message>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMessages();
});

final sendMessageProvider = Provider<Future<void> Function(String)>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return (String content) => repository.sendMessage(content);
});
