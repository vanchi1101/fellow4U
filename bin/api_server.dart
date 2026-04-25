import 'dart:convert';
import 'dart:io';

import 'package:sign_up_in/controllers/chat_controller.dart';
import 'package:sign_up_in/controllers/explore_controller.dart';
import 'package:sign_up_in/controllers/my_trip_controller.dart';
import 'package:sign_up_in/controllers/notifications_controller.dart';
import 'package:sign_up_in/controllers/profile_controller.dart';

Future<void> main() async {
  final exploreController = ExploreController();
  final myTripController = MyTripController();
  final chatController = ChatController();
  final notificationsController = NotificationsController();
  final profileController = ProfileController();

  final routes = <String, Object Function()>{
    '/': () => {
      'message': 'Mock API is running',
      'endpoints': [
        '/api/explore',
        '/api/explore/top-journeys',
        '/api/explore/best-guides',
        '/api/explore/top-experiences',
        '/api/explore/featured-tours',
        '/api/my-trip',
        '/api/my-trip/current-trips',
        '/api/my-trip/next-trips',
        '/api/my-trip/past-trips',
        '/api/my-trip/wish-list',
        '/api/chat',
        '/api/notifications',
        '/api/profile',
        '/api/profile/my-photos',
      ],
    },
    '/api/explore': exploreController.getAllExplore,
    '/api/explore/top-journeys': exploreController.getTopJourneys,
    '/api/explore/best-guides': exploreController.getBestGuides,
    '/api/explore/top-experiences': exploreController.getTopExperiences,
    '/api/explore/featured-tours': exploreController.getFeaturedTours,
    '/api/my-trip': myTripController.getAllMyTrip,
    '/api/my-trip/current-trips': myTripController.getCurrentTrips,
    '/api/my-trip/next-trips': myTripController.getNextTrips,
    '/api/my-trip/past-trips': myTripController.getPastTrips,
    '/api/my-trip/wish-list': myTripController.getWishList,
    '/api/chat': chatController.getAllChat,
    '/api/notifications': notificationsController.getAllNotifications,
    '/api/profile': profileController.getProfile,
    '/api/profile/my-photos': profileController.getMyPhotos,
  };

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  stdout.writeln(
    'Mock API server running at http://${server.address.address}:${server.port}',
  );

  await for (final request in server) {
    final path = request.uri.path;
    final handler = routes[path];

    request.response.headers.contentType = ContentType.json;
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add(
      'Access-Control-Allow-Methods',
      'GET, OPTIONS',
    );
    request.response.headers.add(
      'Access-Control-Allow-Headers',
      'Content-Type',
    );

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
      continue;
    }

    if (request.method != 'GET') {
      request.response.statusCode = HttpStatus.methodNotAllowed;
      request.response.write(
        jsonEncode({
          'error': 'Method not allowed',
          'allowedMethods': ['GET'],
        }),
      );
      await request.response.close();
      continue;
    }

    if (handler == null) {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write(
        jsonEncode({'error': 'Endpoint not found', 'path': path}),
      );
      await request.response.close();
      continue;
    }

    request.response.statusCode = HttpStatus.ok;
    request.response.write(
      const JsonEncoder.withIndent('  ').convert(handler()),
    );
    await request.response.close();
  }
}
