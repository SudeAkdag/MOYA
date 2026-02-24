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