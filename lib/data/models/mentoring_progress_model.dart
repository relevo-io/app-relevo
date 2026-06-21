class MentoringProgress {
  final String id;
  final String userId;
  final List<String> completedModules;
  final int progressPercentage;

  MentoringProgress({
    required this.id,
    required this.userId,
    required this.completedModules,
    required this.progressPercentage,
  });

  factory MentoringProgress.fromJson(Map<String, dynamic> json) {
    return MentoringProgress(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      completedModules: json['completedModules'] != null
          ? List<String>.from(json['completedModules'])
          : [],
      progressPercentage: json['progressPercentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'completedModules': completedModules,
      'progressPercentage': progressPercentage,
    };
  }
}
