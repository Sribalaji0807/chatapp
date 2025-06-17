import 'package:chatapp/ui/LoadingWidget.dart';
import 'package:chatapp/ui/LoginWidget.dart';
import 'package:chatapp/ui/ProfilePage.dart';
import 'package:chatapp/ux/FirebaseService.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:chatapp/ux/Provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * 0.7;
    final double fieldButtonWidth = MediaQuery.of(context).size.width * 0.3;
    final loading = ref.watch(credentialsProvider).loading ?? false;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child:
            loading!
                ? LoadingWidget()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "SignUp",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),

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
                              passwordController.text.isEmpty ||
                              ConfirmpasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please enter email and password",
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          } else if (passwordController.text !=
                              ConfirmpasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Password doesn't match"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            return;
                          }
                          ref
                              .read(credentialsProvider.notifier)
                              .setLoading(true);
                          bool res = await Firebaseservice().SignUp(
                            emailController.text,
                            passwordController.text,
                          );
                          if (res) {
                            ref.read(credentialsProvider.notifier).setLoading(false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("SignUp successful"),
                                duration: const Duration(milliseconds: 300),
                              ),
                            );

                            Getit().RegisterSocketConnection();

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          } else {
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
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginWidget(),
                              ),
                            );
                          },
                          child: Text("Login"),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
