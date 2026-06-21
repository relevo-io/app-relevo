class Rating {
  final String id;
  final String chat;
  final dynamic fromUser; // Can be a String ID or a Map with fullName/id
  final String toUser;
  final String ratedRole; // 'OWNER' | 'INTERESTED'
  final double score;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Rating({
    required this.id,
    required this.chat,
    required this.fromUser,
    required this.toUser,
    required this.ratedRole,
    required this.score,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['_id'] ?? json['id'] ?? '',
      chat: json['chat'] is Map ? (json['chat']['_id'] ?? json['chat']['id'] ?? '') : (json['chat'] ?? ''),
      fromUser: json['fromUser'],
      toUser: json['toUser'] ?? '',
      ratedRole: json['ratedRole'] ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  String get senderName {
    if (fromUser is Map) {
      return fromUser['fullName'] ?? '';
    }
    return '';
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chat': chat,
      'fromUser': fromUser,
      'toUser': toUser,
      'ratedRole': ratedRole,
      'score': score,
      'comment': comment,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class RatingSummary {
  final double average;
  final int count;

  RatingSummary({
    required this.average,
    required this.count,
  });

  factory RatingSummary.fromJson(Map<String, dynamic> json) {
    return RatingSummary(
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
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

class MyRatingsResponse {
  final RatingSummary asOwner;
  final RatingSummary asInterested;
  final List<Rating> ratings;

  MyRatingsResponse({
    required this.asOwner,
    required this.asInterested,
    required this.ratings,
  });

  factory MyRatingsResponse.fromJson(Map<String, dynamic> json) {
    final ratingsList = json['ratings'] as List? ?? [];
    return MyRatingsResponse(
      asOwner: RatingSummary.fromJson(json['asOwner'] ?? {}),
      asInterested: RatingSummary.fromJson(json['asInterested'] ?? {}),
      ratings: ratingsList.map((r) => Rating.fromJson(r)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asOwner': asOwner.toJson(),
      'asInterested': asInterested.toJson(),
      'ratings': ratings.map((r) => r.toJson()).toList(),
    };
  }
}
