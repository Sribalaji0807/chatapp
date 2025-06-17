import 'dart:convert';

import 'package:chatapp/ui/MessagePage.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:chatapp/ux/Provider.dart';
import 'package:chatapp/ux/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:chatapp/ux/FirebaseService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  List<String> contacts = [];
  Map<String, List> contactsMap = {};
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.listen(credentialsProvider, (previous, next) => getContacts());
    // });
    // if (_initialized == false) {
    //   getContacts();
    //   _initialized = true;
    // }
    setup();
  }

  void setup() async {
    await getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          contacts.isEmpty
              ? Center(child: const Text("No Contacts"))
              : ListView.builder(
                itemCount: contacts.length,
                itemBuilder:
                    (context, index) => contactContainer(
                      contacts[index],
                      contactsMap[contacts[index]]!,
                    ),
              ),
    );
  }

  Future<void> getContacts() async {
    Map<String, List> Contacts = {};
    Contacts = await getIt<Firebaseservice>().getContacts();
    final SharedPreferences prefs = getIt<SharedPreferences>();
    prefs.setString('Contacts', json.encode(Contacts));
    //print(contactsJson);
    print("contacts ${Contacts}");
    // Contacts = await Map<String, String>.from(json.decode(contactsJson));
    setState(() {
      contacts = Contacts.keys.toList();
      contactsMap = Contacts;
    });
  }

  Widget contactContainer(String name, List contact) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MessagePage(friend: name, friendid: contact[0]!),
          ),
        );
        // navigate or do whatever
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(radius: 20, backgroundImage: NetworkImage(contact[1]),
          ),
Container(
  margin: const EdgeInsets.only(left: 16),
  child:            Text(name, style: TextStyle(fontSize: 20)),

)
          ],
        ),
      ),
    );
  }
}
