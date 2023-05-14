import 'dart:io';

class UserModel {
  late String uid;
  late String email;
  late String name;
  late String phone;
  late String bio;
  File? profileImg;
  File? coverImg;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.bio,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    bio = json['bio'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'bio': bio,
    };
  }
}
