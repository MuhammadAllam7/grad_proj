class MessageModel {
  late String text;
  late String sender;
  late String receiver;

  MessageModel({
    required this.text,
    required this.sender,
    required this.receiver,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'sender': sender,
      'receiver': receiver,
    };
  }

  MessageModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    sender = json['sender'];
    receiver = json['receiver'];
  }
}
