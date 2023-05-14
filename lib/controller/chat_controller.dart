import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_doctor/model/message.dart';

import '../main.dart';
import '../model/user.dart';

class ChatController extends GetxController {
  var msgController = TextEditingController();

  List<UserModel> allUsers = [];
  List<String> usersImgs = [];
  List<MessageModel> messages = [];

  Future<void> getAllUsers() async {
    if (allUsers.isEmpty) {
      final storageRef = FirebaseStorage.instance.ref();
      StringBuffer imgUrl = StringBuffer();

      UserModel userModel;
      final firestore =
          await FirebaseFirestore.instance.collection('users').get();

      final users = firestore.docs;

      for (var user in users) {
        // for getting users
        userModel = UserModel.fromJson(user.data());
        if (userModel.uid != uid!) {
          allUsers.add(userModel);

          // for getting data
          imgUrl.write(
            await storageRef
                .child('profile_images/${userModel.uid}.png')
                .getDownloadURL(),
          );
          usersImgs.add(imgUrl.toString());
          imgUrl.clear();
        }
      }
    }
  }

  void sendMsg(String receiver) async {
    if (msgController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(receiver)
          .collection('messages')
          .add(
        {
          'text': msgController.text,
          'sender': uid,
          'receiver': receiver,
          'dateTime': FieldValue.serverTimestamp(),
        },
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiver)
          .collection('chats')
          .doc(uid)
          .collection('messages')
          .add(
        {
          'text': msgController.text,
          'sender': uid,
          'receiver': receiver,
          'dateTime': FieldValue.serverTimestamp(),
        },
      );
      msgController.clear();
    }
  }

  Future<void> onCreate() async {
    await getAllUsers();
  }
}
