class Profile {
  final String username;
  final String email;
  final String avatarImage;

  Profile({
    required this.username,
    required this.email,
    required this.avatarImage,
  });
}

class MyPhotos {
  final String image;

  MyPhotos({required this.image});
}
