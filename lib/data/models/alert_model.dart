class Alert {
  final String id;
  final String userId;
  final String revenueRange;
  final bool isActive;

  Alert({
    required this.id,
    required this.userId,
    required this.revenueRange,
    required this.isActive,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      revenueRange: json['revenueRange'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'revenueRange': revenueRange,
      'isActive': isActive,
    };
  }
}
