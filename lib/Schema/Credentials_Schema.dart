class CredentialsSchema {
  String? username;
  String? userid;
  String? token;
  bool? loading;
  Map<String,String>? contacts={};

  CredentialsSchema({this.username, this.userid, this.token,this.loading,this.contacts});
}
