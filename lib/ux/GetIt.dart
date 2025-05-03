import 'package:chatapp/ux/FirebaseService.dart';
import 'package:chatapp/ux/SharedPreferences.dart';
import 'package:chatapp/ux/SocketConnection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

class Getit {
  Future<void> setup() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPrefs);
    getIt.registerSingleton<SharedPreferencesService>(SharedPreferencesService()); // SharedPreferencesService>()
    getIt.registerSingleton<Firebaseservice>(Firebaseservice());
//if(sharedPrefs.getString('username')!=null){getIt.registerSingleton<SocketConnection>(SocketConnection());}
  }

  void RegisterSocketConnection() {
getIt.registerLazySingleton<SocketConnection>(() => SocketConnection());
  }
}
