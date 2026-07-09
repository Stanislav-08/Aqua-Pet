class User {
  final String username;
  final String gender;
  final String activityLevel;
  final double weight;

  const User({
    required this.username,
    required this.gender,
    required this.activityLevel,
    required this.weight,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'gender': gender,
    'activityLevel': activityLevel,
    'weight': weight,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      gender: json['gender'] ?? 'Male',
      activityLevel: json['activityLevel'] ?? 'moderate',
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
    );
  }
}