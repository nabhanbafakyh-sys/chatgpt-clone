import 'package:ai/view_model/chat_vm.dart';
import 'package:ai/widgets/ai_message.dart';
import 'package:ai/widgets/ask_bar.dart';
import 'package:ai/widgets/drawer.dart';
import 'package:ai/widgets/loading_indicator.dart';
import 'package:ai/widgets/mode_selecter.dart';
import 'package:ai/widgets/model_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ChatViewModel>(context);
    final controller = vm.textController;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const ChatDrawer(),

      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "ChatGPT",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              vm.newChat();
            },
            icon: const Icon(Icons.edit_square),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: vm.messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 50),

                        SizedBox(height: 20),

                        Text(
                          "How can I help?",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: vm.messages.length,
                    itemBuilder: (context, index) {
                      final msg = vm.messages[index];

                      if (msg.isUser) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 60,
                              top: 8,
                              bottom: 8,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: SelectableText(
                              msg.message,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }

                      return AiMessage(message: msg.message);
                    },
                  ),
          ),

          if (vm.isLoading) const ThinkingIndicator(),
          ChatInputBar(
            modeSelector: ModeSelector(
              mode: vm.selectedMode,
              selectedAgent: vm.selectedAgent,
              onModeChanged: vm.changeMode,
              onAgentChanged: vm.changeAgent,
            ),

            modelSelector: ModelSelector(
              selectedModel: vm.selectedModel,
              onChanged: vm.changeModel,
            ),

            controller: controller,

            hasText: vm.hasText,

            onSend: () async {
              if (controller.text.trim().isEmpty) return;

              await vm.sendMessage(controller.text);

              controller.clear();

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            },

            onMic: () {
              // Voice feature later
            },
          ),
        ],
      ),
    );
  }
}
