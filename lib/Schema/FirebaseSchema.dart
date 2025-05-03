class FirebaseSchema {
  String id;
  String name;
  String email;
  Map<String, String> contacts_RoomId;
  List<dynamic> mailBox;

  FirebaseSchema({
    required this.id,
    required this.name,
    required this.email,
    Map<String, String>? contacts_RoomId,
    List<dynamic>? mailBox,
  })  : contacts_RoomId = contacts_RoomId ?? {},
        mailBox = mailBox ?? [];

  // Getters and Setters
  String get getId => id;
  set setId(String id) => this.id = id;

  String get getName => name;
  set setName(String name) => this.name = name;

  String get getEmail => email;
  set setEmail(String email) => this.email = email;

  Map<String, String> get getContacts_RoomId => contacts_RoomId;
  set setContacts_RoomId(Map<String, String> contacts_RoomId) =>
      this.contacts_RoomId = contacts_RoomId;

  List<dynamic> get getMailBox => mailBox;
  set setMailBox(List<dynamic> mailBox) => this.mailBox = mailBox;

  // Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contacts_RoomId': contacts_RoomId,
      'mailBox': mailBox,
    };
  }

  factory FirebaseSchema.fromJson(Map<String, dynamic> json) {
    return FirebaseSchema(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contacts_RoomId: Map<String, String>.from(json['contacts_RoomId'] ?? {}),
      mailBox: List<dynamic>.from(json['mailBox'] ?? []),
    );
  }
}
