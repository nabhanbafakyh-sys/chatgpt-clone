import 'package:ai/model/agent_model.dart';
import 'package:ai/model/ai_model.dart';
import 'package:flutter/material.dart';

class ModeSelector extends StatelessWidget {
  final AiMode mode;
  final AgentType selectedAgent;
  final ValueChanged<AiMode> onModeChanged;
  final ValueChanged<AgentType> onAgentChanged;

  const ModeSelector({
    super.key,
    required this.mode,
    required this.selectedAgent,
    required this.onModeChanged,
    required this.onAgentChanged,
  });

  String getAgentName(AgentType agent) {
    switch (agent) {
      case AgentType.general:
        return "General";
      case AgentType.flutter:
        return "Flutter";
      case AgentType.coding:
        return "Coding";
      case AgentType.researcher:
        return "Research";
      case AgentType.reportWriter:
        return "Report Writer";
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AiMode>(
      onSelected: (mode) async {
        if (mode == AiMode.agent) {
          onModeChanged(AiMode.agent);

          final agent = await showMenu<AgentType>(
            context: context,
            position: const RelativeRect.fromLTRB(120, 520, 0, 0),
            items: const [
              PopupMenuItem(value: AgentType.general, child: Text("General")),
              PopupMenuItem(value: AgentType.flutter, child: Text("Flutter")),
              PopupMenuItem(value: AgentType.coding, child: Text("Coding")),
              PopupMenuItem(
                value: AgentType.researcher,
                child: Text("Research"),
              ),
              PopupMenuItem(
                value: AgentType.reportWriter,
                child: Text("Report Writer"),
              ),
            ],
          );

          if (agent != null) {
            onAgentChanged(agent);
          }
        } else {
          onModeChanged(mode);
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: AiMode.ask, child: Text("Ask")),
        PopupMenuItem(value: AiMode.agent, child: Text("Agent")),
        PopupMenuItem(value: AiMode.report, child: Text("Report")),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mode == AiMode.agent
                  ? getAgentName(selectedAgent)
                  : mode.name[0].toUpperCase() + mode.name.substring(1),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
