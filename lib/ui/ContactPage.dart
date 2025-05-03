import 'dart:convert';

import 'package:chatapp/ui/MessagePage.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:chatapp/ux/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:chatapp/ux/FirebaseService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<String> contacts = [];
  Map<String, String> contactsMap = {};

  @override

  void initState() {
    super.initState();
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact")),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) => contactContainer(contacts[index]),
      ),
    );
  }

  Future<void> getContacts() async {
    Map<String, String> Contacts = {};
    final SharedPreferences prefs = getIt<SharedPreferences>();
String contactsJson = prefs.getString('Contacts')!;
print(contactsJson);
  
    Contacts = await Map<String, String>.from(json.decode(contactsJson));
    setState(() {
    contacts = Contacts.keys.toList();
    contactsMap = Contacts;
  });
  }

  Widget contactContainer(String name) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    MessagePage(friend: name, friendid: contactsMap[name]!),
          ),
        );
        // navigate or do whatever
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text(name, style: TextStyle(fontSize: 20))],
        ),
      ),
    );
  }
}
