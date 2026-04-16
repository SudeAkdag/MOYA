class UserModel {
  final String? uid; // Bizim için gerekli, opsiyonel yaptık
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String gender;
  final List<String> focusAreas;

  UserModel({
    this.uid,
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
  // [String? documentId] kısmını opsiyonel yaptık. 
  // Takım arkadaşlarının kullandığı 'phone', 'bday' gibi özel anahtarlar birebir korundu.
  factory UserModel.fromMap(Map<String, dynamic> map, [String? documentId]) {
    return UserModel(
      uid: documentId ?? map['uid'] as String?, // Eğer gelirse documentId'yi uid yap
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
      'uid': uid,
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