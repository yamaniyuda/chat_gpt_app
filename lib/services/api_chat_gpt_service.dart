import 'dart:convert';

import 'package:http/http.dart' as Http;

String apiKey = "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";

class ApiChatGptService {
  static String baseUrl = "https://api.openai.com/v1/chat/completions";
  static Map<String, String> header = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $apiKey"
  };

  static sendMessage(String? message) async {
    var respone = await Http.post(
      Uri.parse(baseUrl),
      headers: header,
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
            {
            "role": "user",
            "content": "$message"
            }
          ],
        // "temperature": 0,
        // "max_token": 100,
        // "top_p": 1,
        // "frequency_penalty": 0.00,
        // "presence_penalty": 0.00,
        // "stop": [" Human:", " AI:"]
      })
    );

    if (respone.statusCode == 200) {
      var data = jsonDecode(respone.body.toString());
      var msg = data["choices"][0]["message"]["content"];
      return msg;
    }
  }
}