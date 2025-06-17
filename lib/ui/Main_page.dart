import 'package:chatapp/ui/ContactPage.dart';
import 'package:chatapp/ui/LoginWidget.dart';
import 'package:chatapp/ui/QrWidget.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:chatapp/ux/Provider.dart';
import 'package:chatapp/ux/SharedPreferences.dart';
import 'package:chatapp/ux/SocketConnection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Main_Page extends ConsumerStatefulWidget {
  const Main_Page({super.key});

  @override
  ConsumerState<Main_Page> createState() => _Main_PageState();
}

class _Main_PageState extends ConsumerState<Main_Page> {
  int SelectedIndex = 0;

  final List<Widget> _pages = [ContactPage(), QrWidget()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SelectedIndex == 0 ? Text("Contacts") : Text("QR Code"),
        actions: [
          IconButton(
            onPressed: () async {
              getIt<SharedPreferencesService>().clearUserData();
              getIt<SocketConnection>().dispose();
              ref.read(credentialsProvider.notifier).reset();
              Getit().dipose(); // Give state providers time to reset
              await Future.delayed(Duration(milliseconds: 100));

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginWidget()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(context),
      body: _pages[SelectedIndex],
    );
  }

  Widget BottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) {
        setState(() {
          SelectedIndex = value;
        });
      },
      currentIndex: SelectedIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Contacts"),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "Qr code"),
      ],
    );
  }
}
