import 'dart:async';

import 'package:chatapp/db/MessageSchema.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HiveService {
  final Map<String, Box<MessageSchema>> _boxes = {};
  HiveService() {}
  Future<void> setupHive(String roomId) async {
    if (!_boxes.containsKey(roomId)) {
      _boxes[roomId] = await Hive.openBox<MessageSchema>(roomId);
    }
  }

  Future<void> setMessage(String roomId, MessageSchema message) async {
    await setupHive(roomId);
    print("start");
    await _boxes[roomId]!.add(message);
    print("success");
  }

  Stream<List<MessageSchema>> getMessagesStream(String roomId) async* {
    await setupHive(roomId);
    final box = _boxes[roomId]!;

    final boxListenable = box.listenable();

    final controller = StreamController<List<MessageSchema>>();

    void emitLatestMessages() {
      final allMessages = box.values.toList();
      final last10Messages =
          allMessages.length <= 10
              ? allMessages
              : allMessages.sublist(allMessages.length - 10);
      controller.add(last10Messages);
    }

    emitLatestMessages();

    final listener = () {
      emitLatestMessages();
    };

    // Add listener
    boxListenable.addListener(listener);

    // Close the stream when it's cancelled
    controller.onCancel = () {
      boxListenable.removeListener(listener);
      controller.close();
    };

    yield* controller.stream;
  }
}
