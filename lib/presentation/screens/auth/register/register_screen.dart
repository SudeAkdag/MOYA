import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moya/data/models/user_model.dart';
import '../../main_wrapper.dart';
import 'widgets/profile_image_picker.dart';
import 'widgets/register_text_field.dart';
import 'widgets/focus_area_selector.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllerlar
  final _nameController = TextEditingController();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bdayController = TextEditingController();

  // Seçimler
  String _selectedGender = "Kadın";
  List<String> _selectedAreas = [];
  final List<String> _areas = ["Stres Yönetimi", "Uyku Kalitesi", "Odaklanma", "Anksiyete", "Özgüven", "Mutluluk"];
  File? _pickedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _userController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bdayController.dispose();
    super.dispose();
  }

  // register_screen.dart içindeki _onComplete metodunu bununla değiştirin:

Future<void> _onComplete() async {
  // 1. Basit bir boş alan kontrolü
  if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lütfen zorunlu alanları doldurun.")),
    );
    return;
  }

  try {
    // Yükleniyor göstergesi göster (İsteğe bağlı)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // 2. Veri modelini oluştur
    final newUser = UserModel(
      fullName: _nameController.text.trim(),
      username: _userController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      birthDate: _bdayController.text.trim(),
      gender: _selectedGender,
      focusAreas: _selectedAreas,
    );

    // 3. VERİTABANINA KAYDET (Firestore)
    // 'users' koleksiyonuna kullanıcının e-postasıyla (veya UID ile) kaydediyoruz
    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUser.email) // E-posta benzersiz olduğu için döküman ID'si yapabiliriz
        .set(newUser.toMap());

    if (mounted) {
      Navigator.pop(context); // Loading göstergesini kapat

      // 4. Ana sayfaya yönlendir
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainWrapper()),
        (route) => false,
      );
    }
  } catch (e) {
    if (mounted) Navigator.pop(context); // Hatada loading'i kapat
    debugPrint("Firestore Kayıt Hatası: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Kayıt başarısız: $e")),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("KAYIT OL", style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ProfileImagePicker(onImagePicked: (file) => _pickedImage = file),
            const SizedBox(height: 12),
            Text("MOYA", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.primaryColor)),
            const Text("YOLCULUĞUN BAŞLIYOR", style: TextStyle(fontSize: 10, letterSpacing: 1, color: Colors.grey)),
            
            _buildDivider(theme, "TEMEL BİLGİLER"),
            RegisterTextField(label: "AD SOYAD", icon: Icons.person_outline, controller: _nameController),
            RegisterTextField(label: "E-POSTA", icon: Icons.mail_outline, controller: _emailController),
            
            Row(
              children: [
                Expanded(child: RegisterTextField(label: "KULLANICI ADI", icon: Icons.alternate_email, controller: _userController)),
                const SizedBox(width: 16),
                Expanded(child: RegisterTextField(label: "TELEFON", icon: Icons.phone_android, controller: _phoneController)),
              ],
            ),

            _buildDivider(theme, "KİŞİSEL DETAYLAR"),
            Row(
              children: [
                Expanded(child: _buildGenderDropdown(theme)),
                const SizedBox(width: 16),
                Expanded(child: RegisterTextField(label: "DOĞUM YILI", icon: Icons.calendar_today_outlined, controller: _bdayController)),
              ],
            ),

            _buildDivider(theme, "ODAK ALANLARIN"),
            FocusAreaSelector(
              allAreas: _areas,
              selectedAreas: _selectedAreas,
              onSelected: (area, val) => setState(() => val ? _selectedAreas.add(area) : _selectedAreas.remove(area)),
            ),

            const SizedBox(height: 40),
            _buildSubmitButton(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Container(width: 30, height: 1, color: theme.primaryColor.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.primaryColor.withOpacity(0.6))),
          ),
          Expanded(child: Container(height: 1, color: theme.primaryColor.withOpacity(0.2))),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("CİNSİYET", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.primaryColor.withOpacity(0.8))),
        DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          underline: Container(height: 1, color: theme.primaryColor.withOpacity(0.2)),
          items: ["Kadın", "Erkek", "Diğer"].map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: (v) => setState(() => _selectedGender = v!),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: _onComplete,
        child: const Text("Yolculuğa Başla ✨", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}