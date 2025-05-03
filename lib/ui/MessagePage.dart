import 'dart:async';

import 'package:chatapp/Schema/MessageSchemaServer.dart';
import 'package:chatapp/db/MessageSchema.dart';
import 'package:chatapp/ux/Chat_Provider.dart';
import 'package:chatapp/ux/HiveService.dart';
import 'package:chatapp/ux/Provider.dart';
import 'package:chatapp/ux/SocketConnection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MessagePage extends ConsumerStatefulWidget {
  final String? friend;
  final String? friendid;
  const MessagePage({super.key, required this.friend, required this.friendid});
  @override
  ConsumerState<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends ConsumerState<MessagePage> {
  List<types.Message> _messages = [];
  late String? username;
  late String? userid;
  final TextEditingController _controller = TextEditingController();
  final socket = GetIt.instance.get<SocketConnection>();
  late Stream<List<MessageSchema>> messageBox;

  final SharedPreferences prefs = GetIt.instance.get<SharedPreferences>();
  @override
  void initState() {
    super.initState();
    username = prefs.getString('username');
    userid = prefs.getString('userid');

    _setupBox();
  }

  StreamSubscription<List<MessageSchema>>? _messageSubscription;

  Future<void> _setupBox() async {
    try {
      final stream = HiveService().getMessagesStream(
        "$userid${widget.friendid}",
      );
   _messageSubscription = stream.listen((messages) {
  setState(() {
    _messages = messages.map((element) {
      return types.TextMessage(
        text: element.message,
        author: types.User(id: element.sendBy),
        createdAt: DateTime.parse(element.time).millisecondsSinceEpoch,
        id: const Uuid().v4(),
      );
    }).toList().reversed.toList(); // Optional: reverse to show latest at bottom
  });
});
    } catch (e) {
      print("Error setting up message box: $e");
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  //  void _LoadMessage() {
  //   try {
  //     for (var element in messageBox) {
  //       _addMessage(
  //         types.TextMessage(
  //           text: element.message,
  //           author: types.User(id: element.sendBy),
  //           createdAt: DateTime.parse(element.time).millisecondsSinceEpoch,
  //           id: const Uuid().v4(),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print("Error loading messages: $e");
  //   }
  // }
void _addMessage(types.Message message) {
  try {
    setState(() {
      _messages.add(message);
    });
  } catch (e) {
    print("Error adding message: $e");
  }
}


  void _handleSendPressed(String text) async {
    if (text.trim().isEmpty) return;

    Map<String, String> Send = new Map();
    Send["message"] = text;
    Send["sendTo"] = widget.friend!;
    Send["sendBy"] = username!;
    Send["time"] = DateTime.now().toIso8601String();
    await HiveService().setMessage(
      "${userid}${widget.friendid}",
      MessageSchema(
       Send["message"]!,
        Send["sendBy"]!,
        Send["sendTo"]!,
        Send["time"]!,
      ),
    );
    
    final textMessage = types.TextMessage(
      text: text,
      author: types.User(id: username!),
      createdAt: DateTime.now().microsecondsSinceEpoch,
      id: const Uuid().v4(),
    );

    if (widget.friend != null) {
      socket.publishMessage(Send);
    }

    _controller.clear();
    _addMessage(textMessage);
    //ref.read(chatProvider.notifier).addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {
    final credentials = ref.watch(credentialsProvider);
    username = credentials.username;
    //  List<types.Message> messages = [];
    //     try {
    //       messages = ref.watch(chatProvider);
    //     } catch (e) {
    //       print("Error watching chat provider: $e");
    //     }

    return Scaffold(
      body: Chat(
        messages: _messages,
        onSendPressed: (_) {},
        user: types.User(id: username!),
showUserNames: true,
        customBottomWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type your message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _handleSendPressed(_controller.text);
                },
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
