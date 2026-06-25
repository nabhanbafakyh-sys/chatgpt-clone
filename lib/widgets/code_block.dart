import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatCodeBlock extends StatelessWidget {
  final Widget child;
  final String code;

  const ChatCodeBlock({super.key, required this.child, required this.code});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xff1e1e1e),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          Padding(padding: const EdgeInsets.all(16), child: child),

          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              splashRadius: 18,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: code));
              },
              icon: const Icon(
                Icons.content_copy_rounded,
                size: 20,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
