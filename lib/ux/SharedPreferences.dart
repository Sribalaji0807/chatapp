import 'dart:convert';
import 'dart:core';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences prefs = GetIt.instance.get<SharedPreferences>();

  String? get username => prefs.getString('username');
  String? get token => prefs.getString('token');
  String? get userid => prefs.getString('userid');

  void Update(
    String username,
    String token,
    Map<String, String> contacts,
    String userid,
  ) {
    prefs.setString('username', username);
    prefs.setString('token', token);
    prefs.setString('Contacts', json.encode(contacts));
    prefs.setString('userid', userid);
  }
String findContacts(String name) {
Map<String, String> contact = (jsonDecode(prefs.getString('Contacts')!) as Map<String, dynamic>).cast<String, String>();
return contact[name]!;
}
void setContacts(Map<String, String> contacts) {
  Map<String, String> contact = (jsonDecode(prefs.getString('Contacts')!) as Map<String, dynamic>).cast<String, String>();
  contact.addAll(contacts);
  prefs.setString('Contacts', json.encode(contact));
}
  void setUsername(String username) {
    prefs.setString('username', username);
  }
  void setUserid(String userid) {
    prefs.setString('userid', userid);
  }

  void setToken(String token) {
    prefs.setString('token', token);
  }

  void clearUserData() {
    prefs.remove('username');
    prefs.remove('token');
    prefs.remove('userid');
    prefs.remove('Contacts');
  }
}
