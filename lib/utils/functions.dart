import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:patient_doctor/controller/profile_controller.dart';

import '../main.dart';

void goTo(BuildContext context, Widget screen) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}

void goReplace(BuildContext context, Widget screen) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}

void getxSnackBar(Color color, String msg) {
  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    titleText: const SizedBox(),
    messageText: Text(
      msg,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
  );
}

Future<void> casheData(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<File> getAvatarFromAssets(String path) async {
  final byteData = await rootBundle.load(path);
  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(
    byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    ),
  );
  return file;
}

Future<void> saveImageToLocal(File myImage, String savePath) async {
  final bytes = await myImage.readAsBytes();

  final directory = await getApplicationDocumentsDirectory();
  final imagePath = '${directory.path}/$savePath';

  final image = File(imagePath);
  await image.writeAsBytes(bytes);
}

// helper image load function
Future<File> getLocalSavedImage(String imgPath) async {
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = '${directory.path}/$imgPath';
  return File(imagePath);
}

// main image load function
Future<File> loadImage(String imgPath) async {
  File img = await getLocalSavedImage(imgPath);
  if (img.existsSync()) {
    return img;
  } else {
    switch (imgPath) {
      case 'profile_image.png':
        downloadFromFirebaseStorage('profile_images/', 'profile_image.png');
        break;
      case 'cover_image.png':
        downloadFromFirebaseStorage('cover_images/', 'cover_image.png');
        break;
    }
    img = await getLocalSavedImage(imgPath);
    return img;
  }
}

Future<String> uploadToFirebaseStorage({
  required String saveFolder,
  required File imageFile,
  required bool isPostImage,
  required bool showToast,
}) async {
  final Reference storage;
  if (isPostImage) {
    storage = FirebaseStorage.instance
        .ref('$saveFolder$uid${currentTime(isPostImage)}.png');
  } else {
    storage = FirebaseStorage.instance.ref('$saveFolder$uid.png');
  }
  try {
    await storage.putFile(imageFile);
    if (showToast) {
      getxSnackBar(Colors.green, 'Uploaded Successfully');
    }
    final String imgLink = await storage.getDownloadURL();
    return imgLink;
  } catch (e) {
    if (showToast) {
      getxSnackBar(Colors.red, 'Error while Uploading Image');
    }
    return '';
  }
}

void downloadFromFirebaseStorage(String cloudFolder, String downloadTo) async {
  final storageRef = FirebaseStorage.instance.ref().child(cloudFolder);
  final appDocDir = await getApplicationDocumentsDirectory();
  final filePath = "${appDocDir.absolute}/$downloadTo";
  final file = File(filePath);

  final downloadTask = storageRef.writeToFile(file);

  downloadTask.snapshotEvents.listen(
    (taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          break;
        case TaskState.canceled:
          getxSnackBar(Colors.red, 'Image Downloading has been canceled');
          break;
        case TaskState.error:
          getxSnackBar(Colors.red, 'Error While Downloading Image');
          break;
      }
    },
  );
}

String currentTime(bool forPostPhoto) {
  return forPostPhoto
      ? DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now())
      : DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
}

void bottomSheetChooseImg(
  BuildContext context,
  ProfileController cubit,
  bool forProfile,
) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              forProfile
                  ? cubit.changeProfileImage(ImageSource.gallery)
                  : cubit.changeCoverImage(ImageSource.gallery);
            },
            icon: const Icon(Icons.photo),
          ),
          IconButton(
            onPressed: () {
              forProfile
                  ? cubit.changeProfileImage(ImageSource.camera)
                  : cubit.changeCoverImage(ImageSource.camera);
            },
            icon: const Icon(Icons.camera),
          ),
        ],
      );
    },
  );
}
