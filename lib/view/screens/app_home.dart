import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_doctor/controller/app_controller.dart';
import 'package:patient_doctor/controller/profile_controller.dart';

import '../../controller/chat_controller.dart';
import '../../utils/functions.dart';
import 'feeds/add_post.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final appController = Get.put(AppController(), permanent: true);
  final profileController = Get.put(ProfileController(), permanent: true);
  final chatController = Get.put(ChatController(), permanent: true);
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: Get.find<AppController>(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.titles[controller.currentIndex]),
          ),
          body: controller.screens[controller.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.currentIndex,
            onTap: (index) => controller.changeBottomNav(index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feeds'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: 'People'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
          floatingActionButton: controller.currentIndex == 0
              ? FloatingActionButton(
                  onPressed: () => goTo(context, const AddPostScreen()),
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
