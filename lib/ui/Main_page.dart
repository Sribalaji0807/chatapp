import 'package:chatapp/ui/ContactPage.dart';
import 'package:chatapp/ui/QrWidget.dart';
import 'package:flutter/material.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({super.key});

  @override
  State<Main_Page> createState() => _Main_PageState();
}

class _Main_PageState extends State<Main_Page> {
int SelectedIndex = 0;

final List<Widget> _pages=[
  ContactPage(),
  QrWidget(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
