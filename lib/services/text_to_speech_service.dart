import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  static FlutterTts tts = FlutterTts();

  static initTTS() {
    tts.setLanguage("id-ID");
    // tts.setPitch(0.5);
  }

  static speak(String text) async {
    await tts.awaitSpeakCompletion(true);
    tts.speak(text);
  }
}