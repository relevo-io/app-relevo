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
    };
  }
}
