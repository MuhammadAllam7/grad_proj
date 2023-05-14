import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_doctor/main.dart';
import 'package:patient_doctor/model/user.dart';
import 'package:patient_doctor/utils/constants.dart';
import 'package:patient_doctor/utils/functions.dart';
import 'package:patient_doctor/view/screens/app_home.dart';

import '../view/widgets/snackbar.dart';

class AuthController extends GetxController {
  bool isLoading = false;
  bool passToggle = true;
  bool rePassToggle = true;

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  late String email, password, repassword, name, phone;
  String bio = 'Add bio';
  File? profileImage;
  File? coverImage;
  // validations

  String? emailFieldValidator(String? value) {
    if (value != null) {
      return value.isEmpty
          ? 'please enter email'
          : !value.isValidEmail
              ? 'email address is not valid'
              : null;
    } else {
      return 'please enter email';
    }
  }

  String? passwordFieldValidator(String? value, [bool checkMatching = false]) {
    if (value != null) {
      if (value.isEmpty) {
        return 'password can not empty';
      }
      if (checkMatching) {
        if (password != repassword) {
          return 'password is not matching';
        }
      }
      if (value.length >= 6) {
        return null;
      } else {
        return 'password can not be less that 6 characters.';
      }
    } else {
      return 'please enter password';
    }
  }

  String? nameFieldValidator(String? value) {
    if (value != null) {
      return value.isEmpty
          ? 'please enter name'
          : !value.isValidName
              ? 'name is not valid'
              : null;
    } else {
      return 'please enter name';
    }
  }

  String? phoneFieldValidator(String? value) {
    if (value != null) {
      return value.isEmpty
          ? 'please enter phone number'
          : !value.isValidPhone
              ? 'phone number is not valid'
              : null;
    } else {
      return 'please enter phone number';
    }
  }

  // login and register

  void loginUser(BuildContext context) async {
    loginFormKey.currentState!.save();
    if (loginFormKey.currentState!.validate()) {
      _loadingOn();
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        var user = credential.user;
        if (user != null) {
          uid = user.uid;
          casheData('uid', uid!).then((value) {
            goReplace(context, HomeScreen());
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          mySnackBar(context, 'this email is not registered');
        } else if (e.code == 'wrong-password') {
          mySnackBar(context, 'wrong password');
        } else if (e.code == 'invalid-email') {
          mySnackBar(context, 'invalid email');
        }
      } catch (e) {
        mySnackBar(context, 'something went wrong');
      }
      _loadingOff();
    }
  }

  void registerUser(BuildContext context) async {
    registerFormKey.currentState!.save();
    if (registerFormKey.currentState!.validate()) {
      _loadingOn();
      try {
        // register user to firebase
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        User? user = credential.user;
        // the following to check that user created successfully
        if (user != null) {
          uid = user.uid;
          // add user data to firebase
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .set(UserModel(
                uid: uid!,
                email: email,
                name: name,
                phone: phone,
                bio: bio,
              ).toMap());

          // upload user default profile avatar to firebase
          profileImage =
              await getAvatarFromAssets('assets/images/profile_avatar.png');
          coverImage =
              await getAvatarFromAssets('assets/images/cover_image.jpg');
          uploadToFirebaseStorage(
            saveFolder: 'profile_images/',
            imageFile: profileImage!,
            isPostImage: false,
            showToast: false,
          );
          uploadToFirebaseStorage(
            saveFolder: 'cover_images/',
            imageFile: coverImage!,
            isPostImage: false,
            showToast: false,
          );

          // save default profile avatar to internal storage
          saveImageToLocal(profileImage!, profileImgPath);
          saveImageToLocal(coverImage!, coverImgPath);

          // save user id locally
          casheData('uid', uid!).then((value) {
            goReplace(context, HomeScreen());
          });
        }
      } on FirebaseAuthException catch (e) {
        _loadingOff();
        if (e.code == 'weak-password') {
          mySnackBar(context, 'password is too weak');
        } else if (e.code == 'email-already-in-use') {
          mySnackBar(context, 'account already exists');
        } else if (e.code == 'invalid-email') {
          mySnackBar(context, 'invalid email');
        }
      } catch (error) {
        mySnackBar(context, error.toString());
      }
    }
  }

  void toggleHidePassword(bool rePass) {
    rePass ? rePassToggle = !rePassToggle : passToggle = !passToggle;
    update();
  }

  // on button click show loading on button

  void _loadingOn() {
    isLoading = true;
    update();
  }

  void _loadingOff() {
    isLoading = false;
    update();
  }
}
