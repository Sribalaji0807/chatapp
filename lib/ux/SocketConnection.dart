import 'package:chatapp/Schema/MessageSchemaServer.dart';
import 'package:chatapp/db/MessageSchema.dart';
import 'package:chatapp/ux/Chat_Provider.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:chatapp/ux/HiveService.dart';
import 'package:chatapp/ux/Provider.dart';
import 'package:chatapp/ux/SharedPreferences.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:convert';


class SocketConnection {
  late StompClient stompClient;
  late String? username;
  late String? userid;
  late ProviderContainer ref;
  SocketConnection() {
    ref = ProviderContainer();
    username = ref.read(credentialsProvider).username;
    userid = ref.read(credentialsProvider).userid;
    stompClient = StompClient(
      config: StompConfig(
        url: "${dotenv.env["SOCKET_URL"]}/ws",
        onConnect: onConnectCallback,
        webSocketConnectHeaders: {'Content-Type': 'application/json'},
        stompConnectHeaders: {'username': username!},
        onWebSocketError: (dynamic error) => print("WebSocket Error: $error"),
        onStompError: (StompFrame frame) => print("STOMP Error: ${frame.body}"),
        onDisconnect: (frame) => print("Disconnected"),
        onDebugMessage: (msg) => print("Debug: $msg"),
      ),
    );
    stompClient.activate();
  }

  void onConnectCallback(StompFrame connectFrame) {
    stompClient.subscribe(
      destination: '/user/$username/queue/messages',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          try {
            dynamic rawBody = frame.body;
            if (rawBody is List) {
              try {
                print("rawBody is List");
                rawBody = utf8.decode(rawBody.cast<int>());
              } catch (e) {
                print("Failed to decode rawBody: $e");
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
            print("rawBody ${rawBody}");
            final Map<String, dynamic> messageJson = jsonDecode(rawBody);
            print("messageJson: ${messageJson["message"]}");
final message = MessageSchemaServer.fromJson(
  (messageJson as Map<String, dynamic>).cast<String, String>()
);
            print("message: ${message.message}");
         final prefs= getIt<SharedPreferencesService>();
    String senderid= prefs.findContacts(message.sendTo!=username?message.sendTo:message.sendBy);
print("sender id ${senderid}");
                HiveService().setMessage("${userid}${senderid}", MessageSchema(message.message, message.sendBy, message.sendTo, message.time));
            print("message added");
          } catch (e) {
            print("Error processing message: $e");
          }
        }
      },
    );
    print("user connected");
  }

  void publishMessage(Map<String, String?> message) {
    if (stompClient.connected) {
      stompClient.send(destination: "/app/Exchange", body: jsonEncode(message));
    }
  }
}
