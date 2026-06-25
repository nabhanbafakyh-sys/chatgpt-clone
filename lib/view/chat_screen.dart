import 'package:ai/view_model/chat_vm.dart';
import 'package:ai/widgets/ai_message.dart';
import 'package:ai/widgets/drawer.dart';
import 'package:ai/widgets/loading_indicator.dart';
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
                              top: 8,
                              bottom: 8,
                              left: 60,
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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }

                      return AiMessage(message: msg.message);
                    },
                  ),
          ),
          if (vm.isLoading) ThinkingIndicator(),

          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                Expanded(
                  child: TextField(
                    onSubmitted: (value) async {
                      if (value.trim().isEmpty) return;

                      await vm.sendMessage(value);
                      controller.clear();
                    },
                    controller: controller,
                    minLines: 1,
                    maxLines: 6,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: "Ask anything",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: vm.hasText
                      ? Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
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
                            icon: Icon(
                              Icons.arrow_upward,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20,
                            ),
                          ),
                        )
                      : IconButton(
                          key: const ValueKey("mic"),
                          onPressed: () {},
                          icon: const Icon(Icons.mic_none),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
