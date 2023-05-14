import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_doctor/model/user.dart';
import 'package:patient_doctor/view/screens/chats/chats.dart';
import 'package:patient_doctor/view/screens/feeds/feeds.dart';
import 'package:patient_doctor/view/screens/people/people.dart';

import '../view/screens/profile/settings.dart';

class AppController extends GetxController {
  int currentIndex = 0;
  
  List<Widget> screens = const [
    FeedsScreen(),
    ChatsScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> titles = const [
    'Feeds',
    'Chats',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    update();
  }
}
