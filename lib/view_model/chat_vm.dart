import 'package:ai/model/agent_model.dart';
import 'package:ai/model/ai_model.dart';
import 'package:ai/model/chat_model.dart';
import 'package:ai/model/message_model.dart';
import 'package:ai/model/model_type.dart';
import 'package:ai/service/groq_service.dart';
import 'package:ai/view_model/chat_storage.dart';
import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  final GroqService _service = GroqService();
  final ChatStorage storage = ChatStorage();

  final TextEditingController textController = TextEditingController();

  List<ChatModel> chats = [];

  ChatModel? currentChat;

  List<MessageModel> get messages => currentChat?.messages ?? [];

  bool isLoading = false;

  bool get hasText => textController.text.trim().isNotEmpty;

  ChatViewModel() {
    chats = storage.getChats();

    if (chats.isEmpty) {
      newChat();
    } else {
      currentChat = chats.first;
    }

    textController.addListener(notifyListeners);
  }

  //---------------- MODES ----------------//

  AiMode selectedMode = AiMode.ask;

  void changeMode(AiMode mode) {
    selectedMode = mode;
    notifyListeners();
  }

  //---------------- AGENTS ----------------//

  AgentType selectedAgent = AgentType.general;

  void changeAgent(AgentType agent) {
    selectedAgent = agent;
    notifyListeners();
  }

  String get agentPrompt {
    switch (selectedAgent) {
      case AgentType.general:
        return "You are a helpful AI assistant.";

      case AgentType.flutter:
        return "You are an expert Flutter developer. Always use MVVM architecture and clean code.";

      case AgentType.coding:
        return "You are a senior software engineer. Write production quality code.";

      case AgentType.researcher:
        return "You are an AI researcher. Give detailed explanations.";

      case AgentType.reportWriter:
        return "Generate professional reports with headings and summaries.";
    }
  }

  //---------------- MODELS ----------------//

  ModelType selectedModel = ModelType.llama33;

  void changeModel(ModelType model) {
    selectedModel = model;
    notifyListeners();
  }

  String get currentModel {
    switch (selectedModel) {
      case ModelType.llama33:
        return "llama-3.3-70b-versatile";

      case ModelType.llama4:
        return "meta-llama/llama-4-maverick-17b-128e-instruct";

      case ModelType.qwen3:
        return "qwen/qwen3-32b";

      case ModelType.deepseek:
        return "deepseek-r1-distill-llama-70b";

      case ModelType.gemma2:
        return "gemma2-9b-it";
    }
  }

  String get currentModelName {
    switch (selectedModel) {
      case ModelType.llama33:
        return "Llama 3.3";

      case ModelType.llama4:
        return "Llama 4";

      case ModelType.qwen3:
        return "Qwen 3";

      case ModelType.deepseek:
        return "DeepSeek";

      case ModelType.gemma2:
        return "Gemma 2";
    }
  }

  //---------------- CHAT ----------------//

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

    List<Map<String, String>> history = [];

    if (selectedMode == AiMode.agent) {
      history.add({"role": "system", "content": agentPrompt});
    }

    for (var msg in messages) {
      history.add({
        "role": msg.isUser ? "user" : "assistant",
        "content": msg.message,
      });
    }

    try {
      final reply = await _service.sendMessage(
        model: currentModel,
        messages: history,
      );

      currentChat!.messages.add(
        MessageModel(message: reply, isUser: false, time: DateTime.now()),
      );
    } catch (e) {
      currentChat!.messages.add(
        MessageModel(
          message: "Error : $e",
          isUser: false,
          time: DateTime.now(),
        ),
      );
    }

    isLoading = false;

    await storage.saveChats(chats);

    notifyListeners();
  }

  //---------------- CHAT FUNCTIONS ----------------//

  Future<void> newChat() async {
    final chat = ChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "New Chat",
      createdAt: DateTime.now(),
      messages: [],
    );

    chats.insert(0, chat);

    currentChat = chat;

    await storage.saveChats(chats);

    notifyListeners();
  }

  void openChat(ChatModel chat) {
    currentChat = chat;
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
