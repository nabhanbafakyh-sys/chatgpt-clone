import 'package:hive/hive.dart';
import '../model/chat_model.dart';

class ChatStorage {
  final box = Hive.box<ChatModel>("chat_box");

  List<ChatModel> getChats() {
    return box.values.toList();
  }

  Future<void> saveChats(List<ChatModel> chats) async {
    await box.clear();

    for (var chat in chats) {
      await box.put(chat.id, chat);
    }
  }
}
