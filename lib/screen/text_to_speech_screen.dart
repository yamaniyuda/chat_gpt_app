import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_gpt_app/services/api_chat_gpt_service.dart';
import 'package:chat_gpt_app/services/chat_message_service.dart';
import 'package:chat_gpt_app/services/text_to_speech_service.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({Key? key}) : super(key: key);

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  SpeechToText speechToText = SpeechToText();
  var isListing = false;
  var text = "Hai saya bot, tekan tombol untuk mulai bicara.";
  var scrollController = ScrollController();
  final List<ChatMessageService> chatMessages = [];

  scrollMounted() {
    scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut
    );
  }

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24,  vertical: 18),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 24,
                  color: isListing ? Colors.black87 : Colors.black54,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: chatMessages.length,
                    itemBuilder: (BuildContext context, int index) {
                      var chat = chatMessages[index];
                      return chatBubble(text: chat.text, type: chat.type);
                    }
                  ),
                )
              ),
              const SizedBox(height: 5),
              const Text(
                "Develop by yamani",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 16
                ),
              )
            ],
          ),
        ),
        floatingActionButton: AvatarGlow(
          endRadius: 75.0,
          animate: isListing,
          duration: const Duration(milliseconds: 2000),
          glowColor: Colors.teal.shade800,
          repeat: true,
          repeatPauseDuration: const Duration(milliseconds: 100),
          showTwoGlows: true,
          child: GestureDetector(
            onTapDown: (_) async {
              if (!isListing) {
                var available = await speechToText.initialize();
                if (available) {
                  setState(() {
                    isListing = true;
                    print("mask");
                    print(available);
                    speechToText.listen(
                      onResult: (result) {
                        print(result.recognizedWords);
                        setState(() => text = result.recognizedWords);
                      }
                    );
                  });
                }
              }
            },
            onTapUp: (_) async {
              setState(() {
                 isListing = false;
              });
              speechToText.stop();
              chatMessages.add(ChatMessageService(text: text, type: ChatMessageType.user));
              var msg = await ApiChatGptService.sendMessage(text);
              TextToSpeechService.speak(msg ?? "Tidak dapat menjawab sekarang ya");
              setState(() {
                chatMessages.add(ChatMessageService(text: msg ?? "Tidak dapat menjawab sekarang ya", type: ChatMessageType.bot));
              });
            },
            child: CircleAvatar(
              backgroundColor: Colors.teal.shade800,
              radius: 35,
              child: Icon(isListing ? Icons.mic : Icons.mic_none, color: Colors.white),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget chatBubble({ required text, required ChatMessageType? type }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (type == ChatMessageType.bot) ...(() {
          return [
            CircleAvatar(
              backgroundColor: Colors.teal.shade700,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
          ];
        })(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular((type == ChatMessageType.user) ? 0 : 12),
                bottomRight: const Radius.circular(12),
                bottomLeft: const Radius.circular(12),
                topLeft: Radius.circular((type == ChatMessageType.user) ? 12 : 0)
              )
            ),
            child: Text(
              "$text",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w400
              ),
            ),
          ),
        ),
        if (type == ChatMessageType.user) ...(() {
          return [
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: Colors.teal.shade700,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ];
        })()
      ],
    );
  }
}
