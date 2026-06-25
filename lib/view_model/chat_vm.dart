import 'package:ai/model/chat_model.dart';
import 'package:ai/model/message_model.dart';
import 'package:ai/service/groq_service.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  final GroqService _service = GroqService();

  List<ChatModel> chats = [];
  ChatModel? currentChat;
  List<MessageModel> get messages => currentChat?.messages ?? [];
  bool isLoading = false;
  bool get hasText => textController.text.trim().isNotEmpty;
  final TextEditingController textController = TextEditingController();

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    currentChat!.messages.add(
      MessageModel(message: text, isUser: true, time: DateTime.now()),
    );
    if (currentChat!.messages.length == 1) {
      currentChat!.title = text.length > 30
          ? "${text.substring(0, 30)}..."
          : text;
    }
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
    currentChat!.messages.add(
      MessageModel(message: reply, isUser: false, time: DateTime.now()),
    );
    isLoading = false;
    notifyListeners();
  }

  ChatViewModel() {
    newChat();

    textController.addListener(() {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void newChat() {
    final chat = ChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "New Chat",
      createdAt: DateTime.now(),
      messages: [],
    );

    chats.insert(0, chat);
    currentChat = chat;

    notifyListeners();
  }
}
