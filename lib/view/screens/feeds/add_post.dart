import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_doctor/controller/profile_controller.dart';
import 'package:patient_doctor/utils/functions.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: Get.find<ProfileController>(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            title: const Text(
              'Create Post',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  controller.createPost(
                    posterName: controller.userModel!.name,
                    postDate: currentTime(false),
                    postText: controller.postTxtController.text.trim(),
                    postImg: controller.postImg,
                  );
                  controller.postImg = null;
                },
                child: const Text("Post"),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          FileImage(controller.userModel!.profileImg!),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        controller.userModel!.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      controller: controller.postTxtController,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Post Content...",
                      ),
                    ),
                  ),
                ),
                if (controller.postImg != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: double.infinity,
                          height: 160,
                          child: Image.file(
                            controller.postImg!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.postImg = null;
                          controller.removePostImg();
                        },
                        icon: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.close, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                TextButton(
                  onPressed: () async {
                    controller.postImg = await controller.pickPostImage();
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.image),
                      SizedBox(width: 6),
                      Text('Add photo'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
