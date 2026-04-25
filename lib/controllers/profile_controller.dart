import 'package:sign_up_in/repositories/profile_repository.dart';

class ProfileController {
  ProfileController({ProfileRepository? repository})
    : _repository = repository ?? const ProfileRepository();

  final ProfileRepository _repository;

  Map<String, dynamic> getProfile() => _repository.getProfile();

  Map<String, dynamic> getMyPhotos() {
    final photos = _repository.getMyPhotos();
    return {'myPhotos': photos};
  }
}
