enum ChatMessageType {
  user,
  bot
}

class ChatMessageService {
  String? text;
  ChatMessageType? type;

  ChatMessageService({
    required this.text,
    required this.type
  });
}