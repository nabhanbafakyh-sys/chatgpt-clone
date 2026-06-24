import 'package:ai/model/message_model.dart';
import 'package:ai/service/groq_service.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  final GroqService _service = GroqService();

  List<MessageModel> messages = [];

  bool isLoading = false;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add(MessageModel(message: text, isUser: true));

    isLoading = true;
    notifyListeners();

    List<Map<String, String>> chatHistory = [];

    for (var msg in messages) {
      chatHistory.add({
        "role": msg.isUser ? "user" : "assistant",
        "content": msg.message,
      });
    }

    String reply = await _service.sendMessage(chatHistory);

    messages.add(MessageModel(message: reply, isUser: false));

    isLoading = false;
    notifyListeners();
  }

  void newChat() {
    messages.clear();
    notifyListeners();
  }
}
