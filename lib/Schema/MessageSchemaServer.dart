class MessageSchemaServer {
  final String message;
  final String sendBy;
  final String sendTo;
  final String time;

  MessageSchemaServer({
    required this.message,
    required this.sendBy,
    required this.sendTo,
    required this.time,
  });

  factory MessageSchemaServer.fromJson(Map<String, dynamic> json) {
    return MessageSchemaServer(
      message: json['message'] as String,
      sendBy: json['sendBy'] as String,
      sendTo: json['sendTo'] as String,
      time: json['time'] as String,
    );
  }

  static List<MessageSchemaServer> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MessageSchemaServer.fromJson(json)).toList();
  }}
