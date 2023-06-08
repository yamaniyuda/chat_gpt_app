import 'package:flutter/material.dart';
import 'screen/text_to_speech_screen.dart';
import 'services/text_to_speech_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TextToSpeechService.initTTS();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TextToSpeechScreen(),
    );
  }
}