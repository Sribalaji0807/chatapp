import 'package:chatapp/ui/Main_page.dart';
import 'package:chatapp/ux/FirebaseService.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Signupwidget extends ConsumerStatefulWidget {
  const Signupwidget({super.key});

  @override
  ConsumerState<Signupwidget> createState() => _SignupwidgetState();
}

class _SignupwidgetState extends ConsumerState<Signupwidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ConfirmpasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();

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
              "SignUp",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            SizedBox(height: 12),
            SizedBox(
              width: fieldWidth,
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Name",
                ),
              
              ),
            ),
            SizedBox(height: 12),
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
            SizedBox(height: 12),
            SizedBox(
              width: fieldWidth,
              child: TextField(
                controller: ConfirmpasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "ConfirmPassword",
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
                      passwordController.text.isEmpty || usernameController.text.isEmpty || ConfirmpasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter email and password"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    return;
                  } else if(passwordController.text != ConfirmpasswordController.text){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Password doesn't match"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  }
                  bool res = await Firebaseservice().SignUp(
                    emailController.text,
                    passwordController.text,
                    usernameController.text,
                  );
                  if (res) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("SignUp successful"),
                        duration: const Duration(milliseconds: 300),
                      ),
                    );
                    
                    Getit().RegisterSocketConnection();

                  Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => const Main_Page()),
  (Route<dynamic> route) => false,
);                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Invalid Credentials",
                          style: TextStyle(color: Colors.red),
                        ),
                        duration: const Duration(milliseconds: 300),
                      ),
                    );
                  }
                },
                child: Text("SignUp", style: TextStyle(fontSize: 20)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(" have an account?"),
                TextButton(onPressed: () {}, child: Text("Login")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
