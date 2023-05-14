import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_doctor/controller/chat_controller.dart';
import 'package:patient_doctor/model/message.dart';
import 'package:patient_doctor/model/user.dart';
import 'package:patient_doctor/view/widgets/chat_message.dart';

import '../../../main.dart';

class ChatDetailsScreen extends StatelessWidget {
  final ChatController controller;
  final UserModel receiverModel;
  final String userImg;

  const ChatDetailsScreen({
    required this.controller,
    required this.userImg,
    required this.receiverModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userImg),
            ),
            const SizedBox(width: 6),
            Text(receiverModel.name),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid!)
                .collection('chats')
                .doc(receiverModel.uid)
                .collection('messages')
                .orderBy('dateTime')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var firebaseMessages = snapshot.data?.docs.reversed;

                List<MessageModel> allMessages = [];

                for (var msg in firebaseMessages!) {
                  allMessages.add(
                    MessageModel(
                      text: msg.get('text'),
                      sender: msg.get('sender'),
                      receiver: msg.get('receiver'),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data?.docs.length,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      return Message(
                        msg: allMessages[index].text,
                        isMe: allMessages[index].sender == uid,
                      );
                    },
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: TextField(
              controller: controller.msgController,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: 'type a message...',
                suffixIcon: IconButton(
                  onPressed: () => controller.sendMsg(receiverModel.uid),
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
