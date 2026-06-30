import 'package:hive/hive.dart';
import 'message_model.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 1)
class ChatModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  List<MessageModel> messages;

  ChatModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });
}
