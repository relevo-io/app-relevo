class Offer {
  final String id;
  final String region;
  final String sector;
  final String? revenueRange;
  final String owner;
  final int? creationYear;
  final String? employeeRange;
  final String companyDescription;
  final String? extendedDescription;
  final DateTime? publishedAt;
  final DateTime? createdAt;

  Offer({
    required this.id,
    required this.region,
    required this.sector,
    this.revenueRange,
    required this.owner,
    this.creationYear,
    this.employeeRange,
    required this.companyDescription,
    this.extendedDescription,
    this.publishedAt,
    this.createdAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['_id'] ?? '',
      region: json['region'] ?? '',
      sector: json['sector'] ?? '',
      revenueRange: json['revenueRange'],
      owner: json['owner'] ?? '',
      creationYear: json['creationYear'],
      employeeRange: json['employeeRange'],
      companyDescription: json['companyDescription'] ?? '',
      extendedDescription: json['extendedDescription'],
      publishedAt: json['publishedAt'] != null 
          ? DateTime.parse(json['publishedAt']) 
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'region': region,
      'sector': sector,
      'revenueRange': revenueRange,
      'owner': owner,
      'creationYear': creationYear,
      'employeeRange': employeeRange,
      'companyDescription': companyDescription,
      'extendedDescription': extendedDescription,
      'publishedAt': publishedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
