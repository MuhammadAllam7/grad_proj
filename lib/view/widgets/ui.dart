import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_doctor/controller/profile_controller.dart';
import 'package:patient_doctor/model/postl.dart';
import 'package:patient_doctor/view/screens/feeds/comments.dart';

import '../../main.dart';

class Line extends StatelessWidget {
  const Line({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 2,
      width: double.infinity,
      color: Colors.grey[200],
    );
  }
}

class MyLoading extends StatelessWidget {
  const MyLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: Colors.red,
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({
    required this.controller,
    required this.postModel,
    required this.postID,
    required this.postIndex,
    super.key,
  });
  final ProfileController controller;
  final PostModel postModel;
  final Map<String, dynamic> postID;
  final int postIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                controller.userModel!.profileImg == null
                    ? const CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            AssetImage('assets/images/profile_avatar.png'),
                      )
                    : CircleAvatar(
                        radius: 24,
                        backgroundImage: FileImage(controller.userModel!.profileImg!),
                      ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postModel.posterName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        postModel.postDate,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (uid! == postModel.uid)
                  IconButton(
                    iconSize: 20,
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
              ],
            ),
            const Line(),
            Text(
              postModel.postText,
              style: const TextStyle(
                fontFamily: 'ComicSans',
              ),
            ),
            const SizedBox(height: 10),
            if (postModel.postImgUrl.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(postModel.postImgUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                width: double.infinity,
                height: 140,
              ),
            if (postModel.postImgUrl.isNotEmpty) const SizedBox(height: 8),
            Row(
              children: [
                InkWell(
                  child: GetBuilder<ProfileController>(
                    id: 'likeWidget',
                    init: Get.find<ProfileController>(),
                    builder: (_) {
                      return SizedBox(
                        width: 20,
                        child: postID['liked']
                            ? Image.asset('assets/icons/done_heart.png')
                            : Image.asset('assets/icons/heart.png'),
                      );
                    },
                  ),
                  onTap: () => controller.likePost(postID, postIndex),
                ),
                const SizedBox(width: 5),
                GetBuilder<ProfileController>(
                  id: 'likeCount',
                  builder: (_) =>
                      Text('${controller.posts[postIndex].likesCount}'),
                ),
                const Spacer(),
                InkWell(
                  child: SizedBox(
                    width: 30,
                    child: Image.asset('assets/icons/comment.png'),
                  ),
                  onTap: () => Get.to(() => const CommentsScreen()),
                ),
                const SizedBox(width: 5),
                const Text('120 commnets'),
              ],
            ),
            const Line(),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: FileImage(controller.userModel!.profileImg!),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'write a comment',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const MyTextField({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        border: const OutlineInputBorder(),
        labelText: label,
      ),
    );
  }
}
