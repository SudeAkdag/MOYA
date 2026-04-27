class UserModel {
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String gender;
  final List<String> selectedGoals; 
  final String? experienceLevel;
  final String? dailyTime;
  final List<String>? routines;
  final String? selectedTheme;
  final bool onboardingCompleted;

  UserModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.gender,
    required this.selectedGoals,
    this.experienceLevel,
    this.dailyTime,
    this.routines,
    this.selectedTheme,
    this.onboardingCompleted = false,
  });

  // --- EKSİK OLAN GETTERLAR BURADA ---

  // Kullanıcı adını döndürür, boşsa 'Misafir' der
  String get name => fullName.isNotEmpty ? fullName : 'Misafir';

  // İsim ve soyismin baş harflerini döndürür (Örn: Sude Naz -> SN)
  String get initials {
    if (name == 'Misafir' || name.isEmpty) return 'M';
    
    List<String> names = name.split(' ').where((n) => n.isNotEmpty).toList();
    
    if (names.length >= 2) {
      return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
    }
    
    return name[0].toUpperCase();
  }

  // ---------------------------------

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone'] ?? '',
      birthDate: map['bday'] ?? '',
      gender: map['gender'] ?? '',
      selectedGoals: map['selectedGoals'] != null 
          ? List<String>.from(map['selectedGoals']) 
          : [],
      experienceLevel: map['experienceLevel'] ?? '',
      dailyTime: map['dailyTime'] ?? '',
      routines: map['routines'] != null ? List<String>.from(map['routines']) : [],
      selectedTheme: map['selectedTheme'] ?? 'nature',
      onboardingCompleted: map['onboardingCompleted'] ?? false,
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
      'selectedGoals': selectedGoals, 
      'experienceLevel': experienceLevel,
      'dailyTime': dailyTime,
      'routines': routines,
      'selectedTheme': selectedTheme,
      'onboardingCompleted': onboardingCompleted,
    };
  }
}