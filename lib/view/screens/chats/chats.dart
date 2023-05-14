import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_doctor/controller/chat_controller.dart';
import 'package:patient_doctor/view/screens/chats/chat_details.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: Get.find<ChatController>(),
      builder: (controller) {
        return FutureBuilder<void>(
          future: controller.onCreate(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return controller.allUsers.isEmpty
                  ? const Center(
                      child: Text(
                        'No Users',
                        style: TextStyle(fontSize: 30),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage:
                                      NetworkImage(controller.usersImgs[index]),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    controller.allUsers[index].name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => Get.to(
                            () => ChatDetailsScreen(
                              controller: controller,
                              receiverModel: controller.allUsers[index],
                              userImg: controller.usersImgs[index],
                            ),
                          ),
                        );
                      },
                      itemCount: controller.allUsers.length,
                    );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
