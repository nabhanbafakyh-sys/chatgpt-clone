import 'package:ai/model/model_type.dart';
import 'package:flutter/material.dart';

class ModelSelector extends StatelessWidget {
  final ModelType selectedModel;
  final ValueChanged<ModelType> onChanged;

  const ModelSelector({
    super.key,
    required this.selectedModel,
    required this.onChanged,
  });

  String getModelName(ModelType model) {
    switch (model) {
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

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ModelType>(
      onSelected: onChanged,
      itemBuilder: (context) => const [
        PopupMenuItem(value: ModelType.llama33, child: Text("Llama 3.3")),
        PopupMenuItem(value: ModelType.llama4, child: Text("Llama 4")),
        PopupMenuItem(value: ModelType.qwen3, child: Text("Qwen 3")),
        PopupMenuItem(value: ModelType.deepseek, child: Text("DeepSeek R1")),
        PopupMenuItem(value: ModelType.gemma2, child: Text("Gemma 2")),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(getModelName(selectedModel)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
