import 'package:sign_up_in/repositories/explore_repository.dart';

class ExploreController {
  ExploreController({ExploreRepository? repository})
    : _repository = repository ?? const ExploreRepository();

  final ExploreRepository _repository;

  Map<String, dynamic> getAllExplore() {
    final topJourneys = _repository.getTopJourneys();
    final bestGuides = _repository.getBestGuides();
    final topExperiences = _repository.getTopExperiences();
    final featuredTours = _repository.getFeaturedTours();

    return {
      'topJourneys': topJourneys,
      'bestGuides': bestGuides,
      'topExperiences': topExperiences,
      'featuredTours': featuredTours,
    };
  }

  List<Map<String, dynamic>> getTopJourneys() => _repository.getTopJourneys();

  List<Map<String, dynamic>> getBestGuides() => _repository.getBestGuides();

  List<Map<String, dynamic>> getTopExperiences() =>
      _repository.getTopExperiences();

  List<Map<String, dynamic>> getFeaturedTours() =>
      _repository.getFeaturedTours();
}
