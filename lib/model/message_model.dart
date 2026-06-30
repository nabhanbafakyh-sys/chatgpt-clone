import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 0)
class MessageModel {
  @HiveField(0)
  String message;

  @HiveField(1)
  bool isUser;

  @HiveField(2)
  DateTime time;

  MessageModel({
    required this.message,
    required this.isUser,
    required this.time,
  });
}
