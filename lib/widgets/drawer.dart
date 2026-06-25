import 'package:flutter/material.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                const Expanded(
                  child: Text(
                    "ChatGPT",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                _DrawerTile(
                  icon: Icons.auto_stories_outlined,
                  title: "Library",
                ),
                _DrawerTile(icon: Icons.folder_outlined, title: "Projects"),
                _DrawerTile(icon: Icons.schedule_outlined, title: "Scheduled"),
                _DrawerTile(icon: Icons.apps_outlined, title: "Apps"),
                _DrawerTile(icon: Icons.image_outlined, title: "Images"),

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

          Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(radius: 18, child: Text("ZN")),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text(
                    "Zyd Nabhan",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _DrawerTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {},
    );
  }
}
