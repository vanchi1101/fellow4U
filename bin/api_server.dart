import 'dart:convert';
import 'dart:io';

import 'package:sign_up_in/server/sql_server_database.dart';

Future<void> main() async {
  final database = SqlServerDatabase();

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  stdout.writeln(
    'API server running at http://${server.address.address}:${server.port}',
  );

  await for (final request in server) {
    request.response.headers.contentType = ContentType.json;
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add(
      'Access-Control-Allow-Methods',
      'GET, POST, PUT, OPTIONS',
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

    try {
      final response = await _handleRequest(request, database);
      request.response.statusCode = response.statusCode;
      request.response.write(
        const JsonEncoder.withIndent('  ').convert(response.body),
      );
    } catch (error) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write(
        jsonEncode({
          'success': false,
          'message': 'Server error',
          'details': error.toString(),
        }),
      );
    } finally {
      await request.response.close();
    }
  }
}

Future<_ApiResponse> _handleRequest(
  HttpRequest request,
  SqlServerDatabase database,
) async {
  final path = request.uri.path;
  final method = request.method.toUpperCase();
  final body = await _readBody(request);

  if (path == '/') {
    return _ApiResponse.ok({
      'message': 'API is running',
      'database': database.databaseName,
      'serverInstance': database.serverInstance,
      'endpoints': <String>[
        'GET /api/explore',
        'GET /api/my-trip?userId=1',
        'GET /api/chat?userId=1',
        'GET /api/notifications?userId=1',
        'GET /api/profile?userId=1',
        'GET /api/users',
        'POST /api/auth/login',
        'POST /api/auth/register',
        'POST /api/auth/logout',
        'PUT /api/profile',
      ],
    });
  }

  if (path == '/api/users' && method == 'GET') {
    final users = await database.queryList('''
SELECT
  UserId AS id,
  FirstName AS firstName,
  LastName AS lastName,
  Email AS email,
  Role AS role,
  Country AS country,
  AvatarImage AS avatarImage
FROM dbo.Users
ORDER BY UserId;
''');
    return _ApiResponse.ok({'success': true, 'users': users});
  }

  if (path == '/api/auth/login' && method == 'POST') {
    final email = (body['email'] as String? ?? '').trim();
    final password = (body['password'] as String? ?? '').trim();
    if (email.isEmpty || password.isEmpty) {
      return _ApiResponse.badRequest({
        'success': false,
        'message': 'Email va password khong duoc de trong.',
      });
    }

    final user = await database.queryObject('''
SELECT TOP 1
  UserId AS id,
  FirstName AS firstName,
  LastName AS lastName,
  CONCAT(FirstName, ' ', LastName) AS username,
  Email AS email,
  Role AS role,
  Country AS country,
  AvatarImage AS avatarImage
FROM dbo.Users
WHERE Email = ${SqlServerDatabase.sqlString(email)}
  AND [Password] = ${SqlServerDatabase.sqlString(password)};
''');

    if (user == null) {
      return _ApiResponse.unauthorized({
        'success': false,
        'message': 'Email hoac password khong dung.',
      });
    }

    return _ApiResponse.ok({
      'success': true,
      'message': 'Dang nhap thanh cong.',
      'user': user,
    });
  }

  if (path == '/api/auth/register' && method == 'POST') {
    final firstName = (body['firstName'] as String? ?? '').trim();
    final lastName = (body['lastName'] as String? ?? '').trim();
    final email = (body['email'] as String? ?? '').trim();
    final password = (body['password'] as String? ?? '').trim();
    final role = (body['role'] as String? ?? '').trim().toLowerCase();
    final country = (body['country'] as String? ?? '').trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        role.isEmpty) {
      return _ApiResponse.badRequest({
        'success': false,
        'message': 'Vui long nhap day du thong tin dang ky.',
      });
    }

    if (!<String>{'traveller', 'guide'}.contains(role)) {
      return _ApiResponse.badRequest({
        'success': false,
        'message': 'Role khong hop le.',
      });
    }

    final existingUser = await database.queryObject('''
SELECT TOP 1 UserId AS id
FROM dbo.Users
WHERE Email = ${SqlServerDatabase.sqlString(email)};
''');

    if (existingUser != null) {
      return _ApiResponse.conflict({
        'success': false,
        'message': 'Email da ton tai.',
      });
    }

    final avatarImage = role == 'guide'
        ? 'assets/explore/guide1.png'
        : 'assets/profile/profile2.png';
    final createdUser = await database.queryObject('''
INSERT INTO dbo.Users (FirstName, LastName, Email, [Password], Role, Country, AvatarImage)
VALUES (
  ${SqlServerDatabase.sqlString(firstName)},
  ${SqlServerDatabase.sqlString(lastName)},
  ${SqlServerDatabase.sqlString(email)},
  ${SqlServerDatabase.sqlString(password)},
  ${SqlServerDatabase.sqlString(role)},
  ${SqlServerDatabase.sqlString(country.isEmpty ? 'Vietnam' : country)},
  ${SqlServerDatabase.sqlString(avatarImage)}
);

DECLARE @NewUserId INT = SCOPE_IDENTITY();

INSERT INTO dbo.ProfilePhotos (UserId, ImagePath)
VALUES
(@NewUserId, 'assets/profile/myphoto1.png'),
(@NewUserId, 'assets/profile/myphoto2.png'),
(@NewUserId, 'assets/profile/myphoto3.png'),
(@NewUserId, 'assets/profile/myphoto4.png');

SELECT
  UserId AS id,
  FirstName AS firstName,
  LastName AS lastName,
  CONCAT(FirstName, ' ', LastName) AS username,
  Email AS email,
  Role AS role,
  Country AS country,
  AvatarImage AS avatarImage
FROM dbo.Users
WHERE UserId = @NewUserId;
''');

    return _ApiResponse.created({
      'success': true,
      'message': 'Dang ky thanh cong.',
      'user': createdUser,
    });
  }

  if (path == '/api/auth/logout' && method == 'POST') {
    return _ApiResponse.ok({
      'success': true,
      'message': 'Dang xuat thanh cong.',
    });
  }

  if (path == '/api/profile' && method == 'GET') {
    final userId = int.tryParse(request.uri.queryParameters['userId'] ?? '');
    if (userId == null) {
      return _ApiResponse.badRequest({
        'success': false,
        'message': 'Thieu userId.',
      });
    }

    final profile = await _getProfile(database, userId);
    if (profile == null) {
      return _ApiResponse.notFound({
        'success': false,
        'message': 'Khong tim thay user.',
      });
    }
    return _ApiResponse.ok({'success': true, 'profile': profile});
  }

  if (path == '/api/profile' && method == 'PUT') {
    final userId = body['userId'] is int
        ? body['userId'] as int
        : int.tryParse('${body['userId'] ?? ''}');
    final firstName = (body['firstName'] as String? ?? '').trim();
    final lastName = (body['lastName'] as String? ?? '').trim();

    if (userId == null || firstName.isEmpty || lastName.isEmpty) {
      return _ApiResponse.badRequest({
        'success': false,
        'message': 'userId, firstName va lastName la bat buoc.',
      });
    }

    await database.queryObject('''
UPDATE dbo.Users
SET
  FirstName = ${SqlServerDatabase.sqlString(firstName)},
  LastName = ${SqlServerDatabase.sqlString(lastName)}
WHERE UserId = $userId;

SELECT CAST(1 AS INT) AS updated;
''');

    final profile = await _getProfile(database, userId);
    return _ApiResponse.ok({
      'success': true,
      'message': 'Cap nhat profile thanh cong.',
      'profile': profile,
    });
  }

  if (path == '/api/profile/my-photos' && method == 'GET') {
    final userId = int.tryParse(request.uri.queryParameters['userId'] ?? '');
    if (userId == null) {
      return _ApiResponse.badRequest({
        'success': false,
        'message': 'Thieu userId.',
      });
    }
    final photos = await database.queryList('''
SELECT ImagePath AS image
FROM dbo.ProfilePhotos
WHERE UserId = $userId
ORDER BY PhotoId;
''');
    return _ApiResponse.ok({'success': true, 'myPhotos': photos});
  }

  if (path == '/api/explore' && method == 'GET') {
    final explore = await database.queryObject('''
SELECT
  JSON_QUERY((
    SELECT
      JourneyLocation AS journeyLocation,
      JourneyImage AS journeyImage,
      CONVERT(VARCHAR(10), JourneySetoffDate, 23) AS journeySetoffDate,
      JourneyWithin AS journeyWithin,
      JourneyPrice AS journeyPrice
    FROM dbo.Journeys
    ORDER BY JourneyId
    FOR JSON PATH
  )) AS topJourneys,
  JSON_QUERY((
    SELECT
      NameGuide AS nameGuide,
      ImageGuide AS imageGuide,
      LocationGuide AS locationGuide,
      CAST(Rating AS FLOAT) AS rating,
      Reviews AS reviews
    FROM dbo.Guides
    ORDER BY GuideId
    FOR JSON PATH
  )) AS bestGuides,
  JSON_QUERY((
    SELECT
      ExperienceDescription AS experienceDescription,
      ExperienceImage AS experienceImage
    FROM dbo.Experiences
    ORDER BY ExperienceId
    FOR JSON PATH
  )) AS topExperiences,
  JSON_QUERY((
    SELECT
      TourName AS tourName,
      TourImage AS tourImage,
      CONVERT(VARCHAR(10), TourSetoffDate, 23) AS tourSetoffDate,
      TourWithin AS tourWithin,
      CAST(TourRating AS FLOAT) AS tourRating,
      TourLikes AS tourLikes,
      TourPrice AS tourPrice
    FROM dbo.FeaturedTours
    ORDER BY TourId
    FOR JSON PATH
  )) AS featuredTours
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
''');
    return _ApiResponse.ok(explore ?? <String, dynamic>{});
  }

  if (path == '/api/my-trip' && method == 'GET') {
    final userId = int.tryParse(request.uri.queryParameters['userId'] ?? '');
    if (userId == null) {
      return _ApiResponse.badRequest({
        'success': false,
        'message': 'Thieu userId.',
      });
    }

    final myTrip = await database.queryObject('''
SELECT
  JSON_QUERY((
    SELECT
      NameGuide AS nameGuide,
      [Location] AS location,
      CONVERT(VARCHAR(10), TripDate, 23) AS date,
      Duration AS duration,
      CAST(Price AS FLOAT) AS price,
      ImagePath AS image
    FROM dbo.Trips
    WHERE UserId = $userId AND Category = 'current'
    ORDER BY TripId
    FOR JSON PATH
  )) AS currentTrips,
  JSON_QUERY((
    SELECT
      NameGuide AS nameGuide,
      [Location] AS location,
      CONVERT(VARCHAR(10), TripDate, 23) AS date,
      Duration AS duration,
      CAST(Price AS FLOAT) AS price,
      ImagePath AS image
    FROM dbo.Trips
    WHERE UserId = $userId AND Category = 'next'
    ORDER BY TripId
    FOR JSON PATH
  )) AS nextTrips,
  JSON_QUERY((
    SELECT
      NameGuide AS nameGuide,
      [Location] AS location,
      CONVERT(VARCHAR(10), TripDate, 23) AS date,
      Duration AS duration,
      CAST(Price AS FLOAT) AS price,
      ImagePath AS image
    FROM dbo.Trips
    WHERE UserId = $userId AND Category = 'past'
    ORDER BY TripId
    FOR JSON PATH
  )) AS pastTrips,
  JSON_QUERY((
    SELECT
      NameGuide AS nameGuide,
      [Location] AS location,
      CONVERT(VARCHAR(10), TripDate, 23) AS date,
      Duration AS duration,
      CAST(Price AS FLOAT) AS price,
      ImagePath AS image
    FROM dbo.Trips
    WHERE UserId = $userId AND Category = 'wishlist'
    ORDER BY TripId
    FOR JSON PATH
  )) AS wishList
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
''');
    return _ApiResponse.ok(myTrip ?? <String, dynamic>{});
  }

  if (path == '/api/chat' && method == 'GET') {
    final userId = int.tryParse(request.uri.queryParameters['userId'] ?? '');
    if (userId == null) {
      return _ApiResponse.badRequest({
        'success': false,
        'message': 'Thieu userId.',
      });
    }
    final chats = await database.queryList('''
SELECT
  [Name] AS name,
  LastMessage AS lastMessage,
  TimeLabel AS time,
  AvatarImage AS avatarImage
FROM dbo.Chats
WHERE UserId = $userId
ORDER BY ChatId;
''');
    return _ApiResponse.ok({'chatUsers': chats});
  }

  if (path == '/api/notifications' && method == 'GET') {
    final userId = int.tryParse(request.uri.queryParameters['userId'] ?? '');
    if (userId == null) {
      return _ApiResponse.badRequest({
        'success': false,
        'message': 'Thieu userId.',
      });
    }
    final notifications = await database.queryList('''
SELECT
  Title AS title,
  CONVERT(VARCHAR(33), DaySent, 127) AS daySent,
  AvatarImage AS avatarImage,
  ActionIcon AS actionIcon
FROM dbo.Notifications
WHERE UserId = $userId
ORDER BY DaySent DESC;
''');
    return _ApiResponse.ok({'notifications': notifications});
  }

  return _ApiResponse.notFound({
    'success': false,
    'message': 'Endpoint not found.',
    'path': path,
    'method': method,
  });
}

Future<Map<String, dynamic>?> _getProfile(
  SqlServerDatabase database,
  int userId,
) {
  return database.queryObject('''
SELECT
  UserId AS id,
  FirstName AS firstName,
  LastName AS lastName,
  CONCAT(FirstName, ' ', LastName) AS username,
  Email AS email,
  Role AS role,
  Country AS country,
  AvatarImage AS avatarImage,
  JSON_QUERY((
    SELECT ImagePath AS image
    FROM dbo.ProfilePhotos
    WHERE UserId = $userId
    ORDER BY PhotoId
    FOR JSON PATH
  )) AS myPhotos
FROM dbo.Users
WHERE UserId = $userId;
''');
}

Future<Map<String, dynamic>> _readBody(HttpRequest request) async {
  if (request.method.toUpperCase() == 'GET') {
    return <String, dynamic>{};
  }

  final content = await utf8.decoder.bind(request).join();
  if (content.trim().isEmpty) {
    return <String, dynamic>{};
  }

  final decoded = jsonDecode(content);
  if (decoded is Map<String, dynamic>) {
    return decoded;
  }

  return <String, dynamic>{};
}

class _ApiResponse {
  const _ApiResponse(this.statusCode, this.body);

  final int statusCode;
  final Map<String, dynamic> body;

  factory _ApiResponse.ok(Map<String, dynamic> body) =>
      _ApiResponse(HttpStatus.ok, body);

  factory _ApiResponse.created(Map<String, dynamic> body) =>
      _ApiResponse(HttpStatus.created, body);

  factory _ApiResponse.badRequest(Map<String, dynamic> body) =>
      _ApiResponse(HttpStatus.badRequest, body);

  factory _ApiResponse.unauthorized(Map<String, dynamic> body) =>
      _ApiResponse(HttpStatus.unauthorized, body);

  factory _ApiResponse.notFound(Map<String, dynamic> body) =>
      _ApiResponse(HttpStatus.notFound, body);

  factory _ApiResponse.conflict(Map<String, dynamic> body) =>
      _ApiResponse(HttpStatus.conflict, body);
}
