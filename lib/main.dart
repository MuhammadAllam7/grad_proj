import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:patient_doctor/view/screens/app_home.dart';
import 'package:patient_doctor/view/screens/login_and_register/login.dart';
import 'firebase_options.dart';

String? uid;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  uid = prefs.getString('uid');

  Widget screen = (uid == null) ? const LoginScreen() : HomeScreen();
  runApp(MyApp(screen));
}

class MyApp extends StatelessWidget {
  const MyApp(this.screen, {super.key});

  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: screen,
    );
  }
}
