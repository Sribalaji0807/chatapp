import 'package:chatapp/Schema/Credentials_Schema.dart';
import 'package:chatapp/ux/SharedPreferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class Credentials extends Notifier<CredentialsSchema> {
    late final SharedPreferencesService _prefs;


 

  @override
  CredentialsSchema build() {
    _prefs = GetIt.instance.get<SharedPreferencesService>();
    return CredentialsSchema(
      username: _prefs.username,
      userid: _prefs.userid,
      token: _prefs.token,
      loading: false,
      contacts: {}
   
    );
  }
  
void setContacts(Map<String, String> map){
  for (var key in map.keys) {
    state.contacts![key] = map[key]!;
  }
}
  Future<void> update(String username, String userid,String token,Map<String,String> contacts) async {
_prefs.setUsername(username);
    _prefs.setUserid(userid);
    if (token != null) _prefs.setToken(token);
    state = CredentialsSchema(username: username, userid: userid, token: token ?? state.token,loading:false,contacts: contacts);
  }
void setLoading(bool loading){
  state = CredentialsSchema(username: state.username, userid: state.userid, token: state.token,loading:loading);
}
  void setUsername(String username) {
    state = CredentialsSchema(username: username, userid: state.userid);
  }

  void setUserid(String userid) {
    state = CredentialsSchema(username: state.username, userid: userid);
  }

  void reset() {
    state = CredentialsSchema();
  }
}

final credentialsProvider = NotifierProvider<Credentials, CredentialsSchema>(
  Credentials.new,
);
