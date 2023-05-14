import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_doctor/controller/profile_controller.dart';

import '../../widgets/ui.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: Get.find<ProfileController>(),
      builder: (controller) {
        return FutureBuilder<void>(
          future: controller.onCreate(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return RefreshIndicator(
                onRefresh: () => controller.getPosts(true),
                child: Container(
                  color: const Color.fromARGB(255, 232, 232, 232),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: controller.posts.isEmpty
                      ? const Center(
                          child: Text(
                            'No posts',
                            style: TextStyle(fontSize: 30),
                          ),
                        )
                      : SizedBox(
                          height: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return PostWidget(
                                controller: controller,
                                postModel: controller.posts[index],
                                postID: controller.postsIDs[index],
                                postIndex: index,
                              );
                            },
                            itemCount: controller.posts.length,
                          ),
                        ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(
                child: Text(
                  'No posts',
                  style: TextStyle(fontSize: 30),
                ),
              );
            }
          },
        );
      },
    );
  }
}
