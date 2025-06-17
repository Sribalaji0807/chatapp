import 'package:chatapp/Schema/MessageSchemaServer.dart';
import 'package:chatapp/db/MessageSchema.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:chatapp/ux/HiveService.dart';
import 'package:chatapp/ux/Provider.dart';
import 'package:chatapp/ux/SharedPreferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:convert';

class SocketConnection {
  final _prefs = getIt<SharedPreferencesService>();
  late StompClient stompClient;
  late String? username;
  late String? userid;
  late ProviderContainer ref = ProviderContainer();
  SocketConnection() {
    username = ref.read(credentialsProvider).username;
    userid = ref.read(credentialsProvider).userid;
    if (userid == null) return;
    stompClient = StompClient(
      config: StompConfig(
        url: "${dotenv.env["SOCKET_URL"]}/ws",
        onConnect: onConnectCallback,
        webSocketConnectHeaders: {'Content-Type': 'application/json'},
        stompConnectHeaders: {'userid': userid ?? ""},
        onWebSocketError: (dynamic error) => print("WebSocket Error: $error"),
        onStompError: (StompFrame frame) => print("STOMP Error: ${frame.body}"),
        onDisconnect: (frame) => print("Disconnected"),
        onDebugMessage: (msg) => print("Debug: $msg"),
      ),
    );
    stompClient.activate();
  }

  void onConnectCallback(StompFrame connectFrame) async {
    final prefs = getIt<SharedPreferencesService>();

    final response = await http.get(
      Uri.parse(
        "${dotenv.env["SERVER_URL"]}/api/StoredMessages?userid=$userid",
      ),
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final messages = MessageSchemaServer.fromJsonList(
        jsonDecode(response.body),
      );
      if (messages.length > 0) {
        String sender = prefs.findContacts(messages[0].sendBy);
        for (var message in messages) {
          await HiveService().setMessage(
            "${userid}${sender}",
            MessageSchema(
              message.message,
              message.sendBy,
              message.sendTo,
              message.time,
            ),
          );
        }
      }
    }
    stompClient.subscribe(
      destination: '/user/$userid/queue/messages',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          try {
            dynamic rawBody = frame.body;
            if (rawBody is List) {
              try {
                rawBody = utf8.decode(rawBody.cast<int>());
              } catch (e) {
                return;
              }
            }

            // if (rawBody is List) {
            //   try {
            //     print("rawBody is List");
            //     rawBody = utf8.decode(List<int>.from(rawBody));
            //   } catch (e) {
            //     print("Failed to decode rawBody: $e");
            //     return;
            //   }
            // }
            final Map<String, dynamic> messageJson = jsonDecode(rawBody);
            final message = MessageSchemaServer.fromJson(
              (messageJson as Map<String, dynamic>).cast<String, String>(),
            );
            String senderid =
                message.sendTo != userid ? message.sendTo : message.sendBy;

            HiveService().setMessage(
              "${userid}${senderid}",
              MessageSchema(
                message.message,
                message.sendBy,
                message.sendTo,
                message.time,
              ),
            );
          } catch (e) {
            return;
          }
        }
      },
    );
    stompClient.subscribe(
      destination: "/user/$userid/queue/Contacts",
      callback: (StompFrame frame) {
        if (frame.body != null) {
          try {
            dynamic rawBody = frame.body;
            if (rawBody is List) {
              try {
                rawBody = utf8.decode(rawBody.cast<int>());
              } catch (e) {
                return;
              }
            }
            final Map<String, dynamic> messageJson = jsonDecode(rawBody);
            final Map<String, String> Contacts = rawBody as Map<String, String>;
            _prefs.setContacts(Contacts);
            ref.read(credentialsProvider.notifier).setContacts(Contacts);
          } catch (e) {
            print("Error processing message: $e");
          }
        }
      },
    );
  }

  void publishMessage(Map<String, String?> message) {
    if (stompClient.connected) {
      stompClient.send(destination: "/app/Exchange", body: jsonEncode(message));
    }
  }

  void dispose() {
    if (stompClient.connected) {
      stompClient.deactivate();
    }
  }
}
