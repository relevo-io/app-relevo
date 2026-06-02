class MentoringItem {
  final String type; // 'tip', 'question', 'task'
  final String title;
  final String text;
  final List<String>? options;

  MentoringItem({
    required this.type,
    required this.title,
    required this.text,
    this.options,
  });

  factory MentoringItem.fromJson(Map<String, dynamic> json) {
    return MentoringItem(
      type: json['type'] ?? 'tip',
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      options: json['options'] != null ? List<String>.from(json['options']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'text': text,
      if (options != null) 'options': options,
    };
  }
}

class MentoringModule {
  final String id;
  final String title;
  final String description;
  final List<MentoringItem> items;
  final int order;
  final int duration;
  final bool isActive;

  MentoringModule({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
    required this.order,
    required this.duration,
    required this.isActive,
  });

  factory MentoringModule.fromJson(Map<String, dynamic> json) {
    return MentoringModule(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
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
      'title': title,
      'description': description,
      'items': items.map((item) => item.toJson()).toList(),
      'order': order,
      'duration': duration,
      'isActive': isActive,
    };
  }
}
