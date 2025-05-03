import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Chat_Provider extends Notifier<List<types.Message>> {
  @override
  List<types.Message> build() {
    return [];
  }

  void addMessage(types.Message message) {
    try {
      print("started");
      final updated = List<types.Message>.from(state)..add(message);
      state = updated;
    print(updated);
    } catch (e) {
      print("Error adding message: $e");
    }
  }
}

final chatProvider = NotifierProvider<Chat_Provider, List<types.Message>>(
  Chat_Provider.new,
);
