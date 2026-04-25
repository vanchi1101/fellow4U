import 'package:sign_up_in/repositories/my_trip_repository.dart';

class MyTripController {
  MyTripController({MyTripRepository? repository})
    : _repository = repository ?? const MyTripRepository();

  final MyTripRepository _repository;

  Map<String, dynamic> getAllMyTrip() {
    final currentTrips = _repository.getCurrentTrips();
    final nextTrips = _repository.getNextTrips();
    final pastTrips = _repository.getPastTrips();
    final wishList = _repository.getWishList();

    return {
      'currentTrips': currentTrips,
      'nextTrips': nextTrips,
      'pastTrips': pastTrips,
      'wishList': wishList,
    };
  }

  List<Map<String, dynamic>> getCurrentTrips() => _repository.getCurrentTrips();

  List<Map<String, dynamic>> getNextTrips() => _repository.getNextTrips();

  List<Map<String, dynamic>> getPastTrips() => _repository.getPastTrips();

  List<Map<String, dynamic>> getWishList() => _repository.getWishList();
}
