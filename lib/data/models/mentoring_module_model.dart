class MentoringItem {
  final String type; // 'tip', 'question', 'task'
  final String titleKey;
  final String contentKey;

  MentoringItem({
    required this.type,
    required this.titleKey,
    required this.contentKey,
  });

  factory MentoringItem.fromJson(Map<String, dynamic> json) {
    return MentoringItem(
      type: json['type'] ?? 'tip',
      titleKey: json['titleKey'] ?? '',
      contentKey: json['contentKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'titleKey': titleKey,
      'contentKey': contentKey,
    };
  }
}

class MentoringModule {
  final String id;
  final String route; // 'BUY' or 'SELL'
  final String titleKey;
  final String descriptionKey;
  final List<MentoringItem> items;
  final int order;
  final int duration;
  final bool isActive;

  MentoringModule({
    required this.id,
    required this.route,
    required this.titleKey,
    required this.descriptionKey,
    required this.items,
    required this.order,
    required this.duration,
    required this.isActive,
  });

  factory MentoringModule.fromJson(Map<String, dynamic> json) {
    return MentoringModule(
      id: json['_id'] ?? '',
      route: json['route'] ?? 'BUY',
      titleKey: json['titleKey'] ?? '',
      descriptionKey: json['descriptionKey'] ?? '',
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => MentoringItem.fromJson(item))
              .toList()
          : [],
      order: json['order'] ?? 0,
      duration: json['duration'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'route': route,
      'titleKey': titleKey,
      'descriptionKey': descriptionKey,
      'items': items.map((item) => item.toJson()).toList(),
      'order': order,
      'duration': duration,
      'isActive': isActive,
    };
  }
}
