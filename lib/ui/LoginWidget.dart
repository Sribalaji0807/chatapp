import 'package:chatapp/ui/Main_page.dart';
import 'package:chatapp/ux/FirebaseService.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * 0.7;
    final double fieldButtonWidth = MediaQuery.of(context).size.width * 0.3;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: fieldWidth,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: fieldWidth,
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Password",
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: fieldButtonWidth,
              height: 40,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter email and password"),
                        duration: Duration(seconds: 1),
                      ),
                    );  return;
                  }
                  bool res= await Firebaseservice().Login(emailController.text, passwordController.text);
                 
                    Getit().RegisterSocketConnection();
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => const Main_Page()),
  (Route<dynamic> route) => false,
);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Login successful"),
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                child: Text("Login", style: TextStyle(fontSize: 20)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(onPressed: () {}, child: Text("Sign Up")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
