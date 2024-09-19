import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerWidget {
  final _messageController = TextEditingController(); // テキスト入力フィールドの制御

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsyncValue = ref.watch(messagesStreamProvider); // ストリームの監視
    final sendMessage = ref.watch(sendMessageProvider); // メッセージの送信関数を取得

    print('Messages state: ${messagesAsyncValue.toString()}');

    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Chat')),
      body: Column(
        children: [
          Expanded(
            // メッセージの一覧を表示
            child: messagesAsyncValue.when(
              data: (messages) => ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ListTile(
                    title: Text(message.content ?? 'No content'),
                    subtitle: Text(message.userId ?? 'Unknown user'),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                print('Error: $error');
                print('Stack: $stack');
                return Center(child: Text('Error: $error'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () { // メッセージ送信
                    if (_messageController.text.isNotEmpty) {
                      sendMessage(_messageController.text);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}