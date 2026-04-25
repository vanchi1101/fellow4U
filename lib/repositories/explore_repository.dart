class ExploreRepository {
  const ExploreRepository();

  List<Map<String, dynamic>> getTopJourneys() {
    return const [
      {
        'journeyLocation': 'Da Nang - Ba Na',
        'journeyImage': 'assets/explore/journey1.png',
        'journeySetoffDate': '2024-07-15',
        'journeyWithin': '7 days',
        'journeyPrice': 1200,
      },
      {
        'journeyLocation': 'Bangkok, Thailand',
        'journeyImage': 'assets/explore/journey2.png',
        'journeySetoffDate': '2024-08-01',
        'journeyWithin': '5 days',
        'journeyPrice': 1500,
      },
      {
        'journeyLocation': 'Hoi An - My Son',
        'journeyImage': 'assets/explore/journey3.png',
        'journeySetoffDate': '2024-09-10',
        'journeyWithin': '6 days',
        'journeyPrice': 1800,
      },
    ];
  }

  List<Map<String, dynamic>> getBestGuides() {
    return const [
      {
        'nameGuide': 'Tuan Tran',
        'imageGuide': 'assets/explore/guide1.png',
        'locationGuide': 'Da Nang, Vietnam',
        'rating': 4.5,
        'reviews': 1230,
      },
      {
        'nameGuide': 'Emmy',
        'imageGuide': 'assets/explore/guide2.png',
        'locationGuide': 'Hanoi, Vietnam',
        'rating': 4.4,
        'reviews': 1020,
      },
      {
        'nameGuide': 'Linh Hana',
        'imageGuide': 'assets/explore/guide3.png',
        'locationGuide': 'Danang, Vietnam',
        'rating': 5.0,
        'reviews': 1520,
      },
      {
        'nameGuide': 'Khai Ho',
        'imageGuide': 'assets/explore/guide4.png',
        'locationGuide': 'Ho Chi Minh, Vietnam',
        'rating': 4.3,
        'reviews': 1020,
      },
    ];
  }

  List<Map<String, dynamic>> getTopExperiences() {
    return const [
      {
        'experienceDescription': '2 Hour Bicycle Tour exploring Hoian',
        'experienceImage': 'assets/explore/experience1.png',
      },
      {
        'experienceDescription': '1 day at Bana Hill',
        'experienceImage': 'assets/explore/experience2.png',
      },
    ];
  }

  List<Map<String, dynamic>> getFeaturedTours() {
    return const [
      {
        'tourName': 'Da Nang - Ba Na',
        'tourImage': 'assets/explore/featured1.png',
        'tourSetoffDate': '2024-07-15',
        'tourWithin': 7,
        'tourRating': 4.5,
        'tourLikes': 1234,
        'tourPrice': 1300,
      },
      {
        'tourName': 'Bangkok, Thailand',
        'tourImage': 'assets/explore/featured2.png',
        'tourSetoffDate': '2024-08-01',
        'tourWithin': 5,
        'tourRating': 4.4,
        'tourLikes': 999,
        'tourPrice': 1230,
      },
      {
        'tourName': 'Bangkok, Thailand',
        'tourImage': 'assets/explore/featured3.png',
        'tourSetoffDate': '2024-08-01',
        'tourWithin': 5,
        'tourRating': 4.4,
        'tourLikes': 869,
        'tourPrice': 1420,
      },
    ];
  }
}
