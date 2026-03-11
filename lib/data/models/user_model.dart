class UserModel {
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String gender;
  final List<String> focusAreas;

  UserModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.gender,
    required this.focusAreas,
  });

  // Hatanın çözümü tam olarak burada:
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone'] ?? '',
      birthDate: map['bday'] ?? '',
      gender: map['gender'] ?? '',
      // List<dynamic>'i List<String>'e güvenli bir şekilde çeviriyoruz
      focusAreas: List<String>.from(map['focusAreas'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': fullName,
      'username': username,
      'email': email,
      'phone': phoneNumber,
      'bday': birthDate,
      'gender': gender,
      'focusAreas': focusAreas,
    };
  }
}