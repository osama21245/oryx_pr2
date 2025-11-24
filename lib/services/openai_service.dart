import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String apiKey =
      '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';

  static const String baseUrl = 'https://api.openai.com/v1';

  /// Make API call to OpenAI
  Future<String> _callOpenAI(String prompt, double temperature) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': 500,
          'temperature': temperature,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else {
        throw Exception(
            'OpenAI API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to call OpenAI: $e');
    }
  }

  /// Get corrected description (no mistakes, same context)
  Future<String> getCorrectedDescription(String description) async {
    final prompt =
        'Correct any language mistakes in the following property description while keeping the exact same context and meaning. Only fix grammar, spelling, and language errors:\n\n$description';

    return await _callOpenAI(prompt, 0.3);
  }

  /// Get enhanced description (improved and polished)
  Future<String> getEnhancedDescription(String description) async {
    final prompt =
        'Enhance and improve the following property description. Make it more engaging, professional, and appealing while maintaining the original meaning. Fix any language mistakes and make it more attractive to potential buyers/renters:\n\n$description';

    return await _callOpenAI(prompt, 0.7);
  }

  /// Get description with opinion (professional opinion/suggestions)
  Future<String> getDescriptionWithOpinion(String description) async {
    final prompt =
        'Rewrite the following property description with a professional real estate agent\'s opinion. Add persuasive elements, highlight key features more effectively, and make it more compelling. Include professional insights while fixing any language mistakes:\n\n$description';

    return await _callOpenAI(prompt, 0.8);
  }

  /// Get all three options at once
  Future<Map<String, String>> getAllOptions(String description) async {
    try {
      final results = await Future.wait([
        getCorrectedDescription(description),
        getEnhancedDescription(description),
        getDescriptionWithOpinion(description),
      ]);

      return {
        'corrected': results[0],
        'enhanced': results[1],
        'withOpinion': results[2],
      };
    } catch (e) {
      throw Exception('Failed to get descriptions: $e');
    }
  }
}
