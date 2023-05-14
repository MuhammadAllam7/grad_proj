extension StringValidation on String {
  bool get isValidEmail {
    return RegExp(r"^[\w-\\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(this);
  }

  bool get isValidName => RegExp(r"^[a-zA-Z ,.'\-]+$").hasMatch(this);

  bool get isValidPassword =>
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
          .hasMatch(this);

  bool get isValidPhone => RegExp(r"^01[0125]\d{8}$").hasMatch(this);
}

String profileImgPath = 'profile_image.png';
String coverImgPath = 'cover_image.png';
