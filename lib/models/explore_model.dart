class Journey {
  // Create attributes
  final String journeyLocation;
  final String journeyImage;
  final String journeySetoffDate;
  final String journeyWithin;
  final int journeyPrice;

  Journey({
    required this.journeyLocation,
    required this.journeyImage,
    required this.journeySetoffDate,
    required this.journeyWithin,
    required this.journeyPrice,
  });
}

class Guide {
  final String nameGuide;
  final String imageGuide;
  final String locationGuide;
  final double rating; // Thêm thuộc tính rating với giá trị mặc định
  final int reviews; // Thêm thuộc tính reviews để lưu số lượng đánh giá

  Guide({
    required this.nameGuide,
    required this.imageGuide,
    required this.locationGuide,
    required this.rating,
    required this.reviews,
  });

  // Hàm này giúp biến dữ liệu thô thành Object an toàn
  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      nameGuide: json['nameGuide'] ?? 'No Name',
      imageGuide: json['imageGuide'] ?? '',
      locationGuide: json['locationGuide'] ?? 'Unknown',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews'] as int? ?? 0,
    );
  }
}

class Experience {
  final String experienceDescription;
  final String experienceImage;

  Experience({
    required this.experienceDescription,
    required this.experienceImage,
  });
}

class FeaturedTours {
  final String tourName;
  final String tourImage;
  final String tourSetoffDate;
  final int tourWithin;
  final double tourRating;
  final int tourLikes;
  final int tourPrice;

  FeaturedTours({
    required this.tourName,
    required this.tourImage,
    required this.tourSetoffDate,
    required this.tourWithin,
    required this.tourRating,
    required this.tourLikes,
    required this.tourPrice,
  });
}
