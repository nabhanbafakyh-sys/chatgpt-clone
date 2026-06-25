import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageActions extends StatefulWidget {
  final String message;
  final VoidCallback? onRegenerate;

  const MessageActions({super.key, required this.message, this.onRegenerate});

  @override
  State<MessageActions> createState() => _MessageActionsState();
}

class _MessageActionsState extends State<MessageActions> {
  bool copied = false;

  Future<void> copy() async {
    await Clipboard.setData(ClipboardData(text: widget.message));

    setState(() => copied = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => copied = false);
    }
  }

  Widget actionButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 20, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          actionButton(
            icon: copied ? Icons.check : Icons.content_copy_outlined,
            onTap: copy,
          ),

          actionButton(icon: Icons.thumb_up_alt_outlined, onTap: () {}),

          actionButton(icon: Icons.thumb_down_alt_outlined, onTap: () {}),

          actionButton(icon: Icons.volume_up_outlined, onTap: () {}),

          actionButton(icon: Icons.more_horiz, onTap: () {}),
        ],
      ),
    );
  }
}
