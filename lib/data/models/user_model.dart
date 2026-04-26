class UserModel {
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String gender;
  final List<String> focusAreas;
  
  // --- ONBOARDING ALANLARI (TİPLERİ GÜNCELLENDİ) ---
  final List<String>? selectedGoals;   // List yaptık çünkü çoklu seçiyoruz
  final String? experienceLevel; // Çoklu seçim izni verdiysen List olmalı
  final String? dailyTime;            // Genelde tek seçim
  final List<String>? routines;        // Çoklu seçim
  final String? selectedTheme;         // Tek seçim
  final bool onboardingCompleted;

  UserModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.gender,
    required this.focusAreas,
    this.selectedGoals,
    this.experienceLevel,
    this.dailyTime,
    this.routines,
    this.selectedTheme,
    this.onboardingCompleted = false,
  });

  String get name => fullName.isNotEmpty ? fullName : 'Misafir';

  String get initials {
    if (name == 'Misafir') return 'M';
    List<String> names = name.split(' ').where((n) => n.isNotEmpty).toList();
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'M';
  }

  // --- VERİTABANINDAN OKUMA ---
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone'] ?? '',
      birthDate: map['bday'] ?? '',
      gender: map['gender'] ?? '',
      focusAreas: List<String>.from(map['focusAreas'] ?? []),
      
      // Firestore'daki CamelCase isimlerle birebir eşleşmeli
      selectedGoals: map['selectedGoals'] != null ? List<String>.from(map['selectedGoals']) : [],
      experienceLevel: map['experienceLevel'] ?? '',
      dailyTime: map['dailyTime'],
      routines: map['routines'] != null ? List<String>.from(map['routines']) : [],
      selectedTheme: map['selectedTheme'],
      onboardingCompleted: map['onboardingCompleted'] ?? false,
    );
  }

  // --- VERİTABANINA YAZMA ---
  Map<String, dynamic> toMap() {
    return {
      'name': fullName,
      'username': username,
      'email': email,
      'phone': phoneNumber,
      'bday': birthDate,
      'gender': gender,
      'focusAreas': focusAreas,
      
      // Firestore ekran görüntündeki alan isimleri
      'primaryGoal': selectedGoals,
      'experienceLevel': experienceLevel,
      'dailyTime': dailyTime,
      'routines': routines,
      'selectedTheme': selectedTheme,
      'onboardingCompleted': onboardingCompleted,
    };
  }
}