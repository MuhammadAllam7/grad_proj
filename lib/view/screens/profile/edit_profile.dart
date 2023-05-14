import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_doctor/controller/profile_controller.dart';
import 'package:patient_doctor/utils/functions.dart';
import 'package:patient_doctor/view/widgets/ui.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile Screen'),
      ),
      body: GetBuilder<ProfileController>(
        init: Get.find<ProfileController>(),
        builder: (controller) {
          return ListView(
            children: [
              SizedBox(
                height: 210,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: controller.userModel!.coverImg == null
                                ? Image.asset(
                                    'assets/images/cover_image.jpg',
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    controller.userModel!.coverImg!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, right: 10),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                radius: 18,
                                child: IconButton(
                                  onPressed: () {
                                    bottomSheetChooseImg(
                                      context,
                                      controller,
                                      false,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.photo_camera_outlined,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 64,
                          child: controller.userModel!.profileImg == null
                              ? const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 60,
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/profile_avatar.png',
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 60,
                                  backgroundImage: FileImage(
                                    controller.userModel!.profileImg!,
                                  ),
                                ),
                        ),
                        CircleAvatar(
                          radius: 18,
                          child: IconButton(
                            onPressed: () {
                              bottomSheetChooseImg(
                                context,
                                controller,
                                true,
                              );
                            },
                            icon: const Icon(
                              Icons.photo_camera_outlined,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    MyTextField(
                      label: "Your name",
                      controller: controller.nameController,
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      label: "Your bio",
                      controller: controller.bioController,
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      label: "Your phone",
                      controller: controller.phoneController,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        controller.updateModelData();
                      },
                      child: const Text("Update Data"),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
