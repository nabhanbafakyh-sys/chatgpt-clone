import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  final Widget modeSelector;
  final Widget modelSelector;
  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onSend;
  final VoidCallback onMic;

  const ChatInputBar({
    super.key,
    required this.modeSelector,
    required this.modelSelector,
    required this.controller,
    required this.hasText,
    required this.onSend,
    required this.onMic,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Top Row
            Row(
              children: [
                modeSelector,

                const SizedBox(width: 12),

                modelSelector,
              ],
            ),

            const SizedBox(height: 8),

            /// Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 6,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: "Ask anything...",
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: hasText
                      ? Container(
                          key: const ValueKey("send"),
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: onSend,
                            icon: Icon(
                              Icons.arrow_upward,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : IconButton(
                          key: const ValueKey("mic"),
                          onPressed: onMic,
                          icon: const Icon(Icons.mic_none),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
