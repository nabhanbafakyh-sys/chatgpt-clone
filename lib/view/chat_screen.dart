import 'package:ai/view_model/chat_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ChatViewModel>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 60,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "ChatGPT",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.auto_stories_outlined),
                    title: Text(
                      "Library",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),

                  ListTile(
                    leading: Icon(Icons.folder_outlined),
                    title: Text(
                      "Projects",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),

                  ListTile(
                    leading: Icon(Icons.schedule_outlined),
                    title: Text(
                      "Scheduled",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),

                  ListTile(
                    leading: Icon(Icons.apps_outlined),
                    title: Text(
                      "Apps",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),

                  ListTile(
                    leading: Icon(Icons.image_outlined),
                    title: Text(
                      "Images",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      "Recent",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: Theme.of(context).colorScheme.surface, height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(radius: 18, child: Text("ZN")),
                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "Zyd Nabhan",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),

                  IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
                ],
              ),
            ),
          ],
        ),
      ),

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
                            child: Text(
                              msg.message,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          msg.message,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      );
                    },
                  ),
          ),

          if (vm.isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Thinking...",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ),

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
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Ask anything",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                IconButton(onPressed: () {}, icon: const Icon(Icons.mic_none)),

                IconButton(
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
                  icon: const Icon(Icons.arrow_upward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
