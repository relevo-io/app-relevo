class NotificationPreferences {
  final bool newMessages;
  final bool applicationStatus;
  final bool newApplications;
  final bool cvAnalysis;
  final bool offerAlerts;

  NotificationPreferences({
    required this.newMessages,
    required this.applicationStatus,
    required this.newApplications,
    required this.cvAnalysis,
    required this.offerAlerts,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      newMessages: json['newMessages'] ?? true,
      applicationStatus: json['applicationStatus'] ?? true,
      newApplications: json['newApplications'] ?? true,
      cvAnalysis: json['cvAnalysis'] ?? true,
      offerAlerts: json['offerAlerts'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newMessages': newMessages,
      'applicationStatus': applicationStatus,
      'newApplications': newApplications,
      'cvAnalysis': cvAnalysis,
      'offerAlerts': offerAlerts,
    };
  }

  NotificationPreferences copyWith({
    bool? newMessages,
    bool? applicationStatus,
    bool? newApplications,
    bool? cvAnalysis,
    bool? offerAlerts,
  }) {
    return NotificationPreferences(
      newMessages: newMessages ?? this.newMessages,
      applicationStatus: applicationStatus ?? this.applicationStatus,
      newApplications: newApplications ?? this.newApplications,
      cvAnalysis: cvAnalysis ?? this.cvAnalysis,
      offerAlerts: offerAlerts ?? this.offerAlerts,
    );
  }
}

class RatingSummary {
  final double average;
  final int count;

  RatingSummary({required this.average, required this.count});

  factory RatingSummary.fromJson(Map<String, dynamic> json) {
    return RatingSummary(
      average: json['average'] != null ? (json['average'] as num).toDouble() : 0.0,
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'count': count,
    };
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final List<String> roles;
  final String? location;
  final String? bio;
  final String? professionalBackground;
  final String? cv;
  final List<String>? preferredRegions;
  final bool? visible;
  final String? language;
  final String? theme;
  final NotificationPreferences? notificationPreferences;
  final bool? proActive;
  final String? proExpiresAt;
  final RatingSummary? ratingAsOwner;
  final RatingSummary? ratingAsInterested;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.roles,
    this.location,
    this.bio,
    this.professionalBackground,
    this.cv,
    this.preferredRegions,
    this.visible,
    this.language,
    this.theme,
    this.notificationPreferences,
    this.proActive,
    this.proExpiresAt,
    this.ratingAsOwner,
    this.ratingAsInterested,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
      location: json['location'],
      bio: json['bio'],
      professionalBackground: json['professionalBackground'],
      cv: json['cv'],
      preferredRegions: json['preferredRegions'] != null
          ? List<String>.from(json['preferredRegions'])
          : null,
      visible: json['visible'],
      language: json['language'],
      theme: json['theme'],
      notificationPreferences: json['notificationPreferences'] != null
          ? NotificationPreferences.fromJson(json['notificationPreferences'])
          : null,
      proActive: json['proActive'],
      proExpiresAt: json['proExpiresAt']?.toString(),
      ratingAsOwner: json['ratingAsOwner'] != null
          ? RatingSummary.fromJson(json['ratingAsOwner'])
          : null,
      ratingAsInterested: json['ratingAsInterested'] != null
          ? RatingSummary.fromJson(json['ratingAsInterested'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'roles': roles,
      'location': location,
      'bio': bio,
      'professionalBackground': professionalBackground,
      'cv': cv,
      'preferredRegions': preferredRegions,
      'visible': visible,
      'language': language,
      'theme': theme,
      'notificationPreferences': notificationPreferences?.toJson(),
      'proActive': proActive,
      'proExpiresAt': proExpiresAt,
      'ratingAsOwner': ratingAsOwner?.toJson(),
      'ratingAsInterested': ratingAsInterested?.toJson(),
    };
  }
}
