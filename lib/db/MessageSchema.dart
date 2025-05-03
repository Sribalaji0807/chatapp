import 'package:hive/hive.dart';
part 'MessageSchema.g.dart';
@HiveType(typeId: 0)
class MessageSchema extends HiveObject{
  @HiveField(0)
  final String message;
  @HiveField(1)
  final String sendBy;
  @HiveField(2)
  final String sendTo;
  @HiveField(3)
  final String time;

  MessageSchema(this.message, this.sendBy, this.sendTo, this.time);


}
