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

  String get formattedRevenue {
    if (revenueRange == null) return 'Consulta';
    switch (revenueRange) {
      case 'UNDER_100K':
        return '100.000 €';
      case 'BETWEEN_100K_500K':
        return '500.000 €';
      case 'BETWEEN_500K_1M':
        return '1.000.000 €';
      case 'BETWEEN_1M_5M':
        return '5.000.000 €';
      case 'OVER_5M':
        return '8.500.000 €';
      default:
        return 'Detalles';
    }
  }

  String get formattedRevenueShort {
    if (revenueRange == null) return 'Consulta';
    switch (revenueRange) {
      case 'UNDER_100K':
        return '< 100k€';
      case 'BETWEEN_100K_500K':
        return '500k€';
      case 'BETWEEN_500K_1M':
        return '1M€';
      case 'BETWEEN_1M_5M':
        return '5M€';
      case 'OVER_5M':
        return '> 5M€';
      default:
        return 'Detalles';
    }
  }

  static const List<String> revenueOptions = [
    'UNDER_100K',
    'BETWEEN_100K_500K',
    'BETWEEN_500K_1M',
    'BETWEEN_1M_5M',
    'OVER_5M',
  ];

  static const List<String> employeeOptions = [
    '1_5',
    '6_10',
    '11_25',
    '26_50',
    '51_100',
    '100_PLUS',
  ];

  static String formatRevenueRange(String value) {
    switch (value) {
      case 'UNDER_100K':
        return '< 100.000 €';
      case 'BETWEEN_100K_500K':
        return '100.000 € - 500.000 €';
      case 'BETWEEN_500K_1M':
        return '500.000 € - 1.000.000 €';
      case 'BETWEEN_1M_5M':
        return '1.000.000 € - 5.000.000 €';
      case 'OVER_5M':
        return '> 5.000.000 €';
      default:
        return value;
    }
  }

  static String formatEmployeeRange(String value) {
    switch (value) {
      case '1_5':
        return '1 - 5';
      case '6_10':
        return '6 - 10';
      case '11_25':
        return '11 - 25';
      case '26_50':
        return '26 - 50';
      case '51_100':
        return '51 - 100';
      case '100_PLUS':
        return '100+';
      default:
        return value;
    }
  }
}
