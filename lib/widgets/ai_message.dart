import 'package:ai/widgets/code_block.dart';
import 'package:ai/widgets/message_actions.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class AiMessage extends StatelessWidget {
  final String message;

  const AiMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBlock(
            data: message,
            config: MarkdownConfig(
              configs: [
                PreConfig.darkConfig.copy(
                  wrapper: (child, code, language) {
                    return ChatCodeBlock(child: child, code: code);
                  },
                ),

                const CodeConfig(
                  style: TextStyle(
                    backgroundColor: Color(0xFF2D2D2D),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          MessageActions(message: message),
        ],
      ),
    );
  }
}
