class ProfileRepository {
  const ProfileRepository();

  Map<String, dynamic> getProfile() {
    return const {
      'username': 'John Doe',
      'email': 'johndoe@example.com',
      'avatarImage': 'assets/profile/profile2.png',
    };
  }

  List<Map<String, dynamic>> getMyPhotos() {
    return const [
      {'image': 'assets/profile/myphoto1.png'},
      {'image': 'assets/profile/myphoto2.png'},
      {'image': 'assets/profile/myphoto3.png'},
      {'image': 'assets/profile/myphoto4.png'},
    ];
  }
}
