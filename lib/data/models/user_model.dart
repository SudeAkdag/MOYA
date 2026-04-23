class UserModel {
  // uid tamamen kaldırıldı
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

  // --- BİZİM ANA SAYFA İÇİN KÖPRÜLER ---
  // Ana sayfada 'name' kullandık, Profilde 'fullName'. Hata vermemesi için birbirine bağladık:
  String get name => fullName.isNotEmpty ? fullName : 'Misafir';

  // Ana sayfadaki o tatlı ikon için baş harf hesaplayıcı:
  String get initials {
    if (name == 'Misafir') return 'M';
    List<String> names = name.split(' ').where((n) => n.isNotEmpty).toList();
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    if (name.isNotEmpty) {
      return name.substring(0, 1).toUpperCase();
    }
    return 'M';
  }

  // --- ORTAK FROM_MAP FONKSİYONU ---
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      // uid okuma satırı silindi
      fullName: map['name'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone'] ?? '',
      birthDate: map['bday'] ?? '',
      gender: map['gender'] ?? '',
      focusAreas: List<String>.from(map['focusAreas'] ?? []),
    );
  }

  // Takım arkadaşlarının veritabanına yazma fonksiyonu
  Map<String, dynamic> toMap() {
    return {
      // 'uid': uid, satırı tamamen silindi. Artık veritabanında "uid: null" yazmayacak.
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