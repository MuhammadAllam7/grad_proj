import 'dart:io';

class PostModel {
  late String uid;
  late String posterName;
  late String postText;
  late String postDate;
  late String postImgUrl;
  late int likesCount;
  File? postImg;

  PostModel({
    required this.uid,
    required this.posterName,
    required this.postText,
    required this.postDate,
    required this.postImgUrl,
    required this.likesCount,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    posterName = json['posterName'];
    postText = json['postText'];
    postDate = json['postDate'];
    postImgUrl = json['imgUrl'];
    likesCount = json['likesCount'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'posterName': posterName,
      'postText': postText,
      'postDate': postDate,
      'imgUrl': postImgUrl,
      'likesCount': likesCount,
    };
  }
}
