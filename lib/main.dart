import 'package:chatapp/db/MessageSchema.dart';
import 'package:chatapp/ui/ContactPage.dart';
import 'package:chatapp/ui/MessagePage.dart';
import 'package:chatapp/ui/ProfilePage.dart';
import 'package:chatapp/ui/SignUpWidget.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:chatapp/ux/Provider.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/ui/LoginWidget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Getit().setup();
  await Hive.initFlutter();

  Hive.registerAdapter(MessageSchemaAdapter());

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(credentialsProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:ProfilePage(),
     // home: user.username == null ? LoginWidget() : const ContactPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
