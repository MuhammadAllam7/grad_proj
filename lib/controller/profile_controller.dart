import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_doctor/main.dart';
import 'package:patient_doctor/model/postl.dart';
import 'package:patient_doctor/model/user.dart';

import '../utils/constants.dart';
import '../utils/functions.dart';

class ProfileController extends GetxController {
// final likeController = Get.put(LikeController(), permanent: true);
  UserModel? userModel;

  List<PostModel> posts = [];
  List<Map<String, dynamic>> postsIDs = [];
  File? postImg;

  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  final postTxtController = TextEditingController();

  Future<void> onCreate() async {
    await loadUserData();
    await getPosts(false);
    nameController.text = userModel!.name;
    bioController.text = userModel!.bio;
    phoneController.text = userModel!.phone;
  }

  void changeProfileImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      userModel!.profileImg = File(pickedImage.path);
      saveImageToLocal(userModel!.profileImg!, profileImgPath);
      uploadToFirebaseStorage(
        saveFolder: 'profile_images/',
        imageFile: userModel!.profileImg!,
        isPostImage: false,
        showToast: true,
      );
    }
    update();
    Get.back();
  }

  void changeCoverImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      userModel!.coverImg = File(pickedImage.path);
      saveImageToLocal(userModel!.coverImg!, coverImgPath);
      uploadToFirebaseStorage(
        saveFolder: 'cover_images/',
        imageFile: userModel!.coverImg!,
        isPostImage: false,
        showToast: true,
      );
    }
    update();
    Get.back();
  }

  // user text data + profile ~ cover imgs
  Future<void> loadUserData() async {
    if (userModel == null) {
      userModel = await loadUserModel();
      await loadProfileImg();
      await loadCoverImg();
    }
  }

  // user text data
  Future<UserModel> loadUserModel() async {
    var firestore =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return UserModel.fromJson(firestore.data()!);
  }

  Future<void> loadProfileImg() async {
    userModel!.profileImg = await getLocalSavedImage(profileImgPath);
  }

  Future<void> loadCoverImg() async {
    userModel!.coverImg = await getLocalSavedImage(coverImgPath);
  }

  void updateModelData() async {
    userModel!.name = nameController.text;
    userModel!.bio = bioController.text;
    userModel!.phone = phoneController.text;

    final updateModel = UserModel(
      uid: uid!,
      email: userModel!.email,
      name: userModel!.name,
      phone: userModel!.phone,
      bio: userModel!.bio,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(updateModel.toMap())
        .then((value) {
      Get.back();
      getxSnackBar(Colors.green, 'Profile data updated successfully');
    }).catchError((error) {
      getxSnackBar(Colors.red, 'Something went wrong');
    });
    update();
  }

  Future<File?> pickPostImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    File postImg;
    if (pickedImage != null) {
      postImg = File(pickedImage.path);
      update();
      return postImg;
    }
    return null;
  }

  void removePostImg() => update();

  void createPost({
    required String posterName,
    required String postDate,
    required String postText,
    required File? postImg,
  }) async {
    if (postTxtController.text == '' && postImg == null) {
      getxSnackBar(Colors.red, 'Add content or photo!');
    } else {
      Get.back();
      String imgLink = '';
      if (postImg != null) {
        imgLink = await uploadToFirebaseStorage(
          saveFolder: 'posts_images/',
          imageFile: postImg,
          isPostImage: true,
          showToast: true,
        );
      }
      await FirebaseFirestore.instance.collection('posts').add(
            PostModel(
              uid: uid!,
              posterName: posterName,
              postText: postText,
              postDate: postDate,
              postImgUrl: imgLink,
              likesCount: 0,
            ).toMap(),
          );

      postTxtController.text = '';

      update();
    }
  }

  Future<void> getPosts(bool onRefresh) async {
    if (onRefresh) {
      posts.clear();
      postsIDs.clear();
    }

    if (posts.isEmpty || onRefresh) {
      print('object');
      final postsCollection = FirebaseFirestore.instance.collection('posts');
      final postsDocs = await postsCollection.get();

      for (var post in postsDocs.docs) {
        // getting posts
        posts.add(PostModel.fromJson(post.data()));
        // getting my likes on posts
        final likesDoc = await postsCollection
            .doc(post.id)
            .collection('likes')
            .doc(userModel!.uid)
            .get();
        final bool postLiked = likesDoc.exists && likesDoc['like'] == true;
        postsIDs.add({'id': post.id, 'liked': postLiked});
      }
      update();
    }
  }

  void likePost(Map postID, int postIndex) async {
    final postsCollection = FirebaseFirestore.instance.collection('posts');

    final likeDocument = postsCollection
        .doc(postID['id'])
        .collection('likes')
        .doc(userModel!.uid);

    final doc = await likeDocument.get();
    if (doc.exists) {
      final bool isLiked = doc['like'] as bool;
      await likeDocument.set({'like': !isLiked});

      final postsSnapshot = await postsCollection.doc(postID['id']).get();

      if (isLiked) {
        // for getting current num of likes
        int likesCount = postsSnapshot.data()?['likesCount'];
        // for updating the num of likes
        if (likesCount > 0) {
          postsCollection
              .doc(postID['id'])
              .update({'likesCount': --likesCount});
          postsIDs[postIndex]['liked'] = false;
          posts[postIndex].likesCount -= 1;
        }
      } else {
        int likesCount = postsSnapshot.data()?['likesCount'] ?? 0;
        postsCollection.doc(postID['id']).update({'likesCount': ++likesCount});
        postsIDs[postIndex]['liked'] = true;
        posts[postIndex].likesCount += 1;
      }
    } else {
      await likeDocument.set({'like': true});
      postsIDs[postIndex]['liked'] = true;
      posts[postIndex].likesCount += 1;

      final postsSnapshot = await postsCollection.doc(postID['id']).get();
      int likesCount = postsSnapshot.data()?['likesCount'];
      postsCollection.doc(postID['id']).update({'likesCount': ++likesCount});
    }

    update(['likeWidget', 'likeCount']);
  }
}
