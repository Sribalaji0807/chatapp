import 'dart:convert';
import 'package:chatapp/Schema/FirebaseSchema.dart';
import 'package:chatapp/ux/Provider.dart';
import 'package:chatapp/ux/SharedPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class Firebaseservice {
  late FirebaseAuth _auth;
  Firebaseservice() {
    _auth = FirebaseAuth.instance;
    _auth.setLanguageCode("en");
  }
  Future<bool> SignUp(String email, String password, String name) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      final token = await userCredential.user!.getIdToken() as String;
      final response = await http.post(
        Uri.parse("${dotenv.env["SERVER_URL"]}/api/SignUp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "id": userCredential.user!.uid,
          "name": name,
          "cookie": token,
        }),
      );
      if (response.statusCode == 200) {
        stateupdation(name, userCredential.user!.uid, token, {});
        return true;
      }
    }
    return false;
  }

  Future<bool> Login(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user != null) {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          // The user is signed in
          print('User signed in: ${user.email}');
        } else {
          // The user is signed out
          print('User signed out');
        }
      });
      final token = await userCredential.user!.getIdToken() as String;
      print("${dotenv.env['SERVER_URL']}/api/Login");
      final response = await http.post(
        Uri.parse("${dotenv.env["SERVER_URL"]}/api/Login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "id": userCredential.user!.uid,
          "cookie": token,
          "name": "",
        }),
      );
      print("response ${response.body}");
      if (response.statusCode == 200) {
        final FirebaseSchema user = FirebaseSchema.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
        stateupdation(user.getName, user.getId, token, user.getContacts_RoomId);

        return true;
      }
    }
    return false;
  }

  void stateupdation(
    String username,
    String userid,
    String token,
    Map<String, String> contacts,
  ) async {
    GetIt.instance.get<SharedPreferencesService>().Update(
      username,
      token,
      contacts,
      userid,
    );
    final container = ProviderContainer();
    container
        .read(credentialsProvider.notifier)
        .update(username, userid, token);
  }

  Future<Map<String, String>> getContacts() async {
    final refs = ProviderContainer();
    final userid = refs.read(credentialsProvider).userid;
    final response = await http.get(
      Uri.parse("${dotenv.env['SERVER_URL']}/api/GetContacts?userid=${userid}"),
    );
    print(response.body);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      Map<String, String> contacts = Map<String, String>.from(jsonResponse);
      print("contacts ${contacts}");
      return contacts;
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  Future<bool> addContacts(String friendid, String userid) async {
    try {
      final response = await http.post(
        Uri.parse("${dotenv.env['SERVER_URL']}/api/AddContacts"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"friendid": friendid, "userid": userid}),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print("error $e");
    }
    return false;
  }
}
