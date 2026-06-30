import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  final Dio dio = Dio();

  final String apiKey = dotenv.env['groq_api'] ?? '';

  Future<String> sendMessage({
    required String model,
    required List<Map<String, String>> messages,
  }) async {
    try {
      final response = await dio.post(
        "https://api.groq.com/openai/v1/chat/completions",
        options: Options(
          headers: {
            "Authorization": "Bearer $apiKey",
            "Content-Type": "application/json",
          },
        ),
        data: {"model": model, "messages": messages},
      );

      return response.data["choices"][0]["message"]["content"];
    } catch (e) {
      return "Error: $e";
    }
  }
}
