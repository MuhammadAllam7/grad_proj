import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({
    required this.msg,
    required this.isMe,
    Key? key,
  }) : super(key: key);

  final String msg;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Align(
        alignment: isMe ? Alignment.topRight : Alignment.topLeft,
        child: Material(
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(30),
            bottomRight: const Radius.circular(30),
            topLeft: !isMe ? Radius.zero : const Radius.circular(30),
            topRight: isMe ? Radius.zero : const Radius.circular(30),
          ),
          elevation: 5,
          color: isMe ? Colors.blue[800] : Colors.green,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              msg,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
