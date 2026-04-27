// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moya/data/models/user_model.dart';
import 'package:moya/data/services/seed_service.dart';
import '../../main_wrapper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller'lar
  final _nameController = TextEditingController();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(); 
  final _phoneController = TextEditingController();
  final _bdayController = TextEditingController();

  // Seçimler ve Durumlar
  String _selectedGender = "Kadın";
  final List<String> _genders = ["Kadın", "Erkek", "Diğer"];
  bool _obscurePassword = true; // Şifreyi gizle/göster kontrolü

  @override
  void dispose() {
    _nameController.dispose();
    _userController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _bdayController.dispose();
    super.dispose();
  }

  // KAYIT FONKSİYONU
  Future<void> _onComplete() async {
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
        ),
      );

      // 1. ADIM: Firebase Auth ile kullanıcıyı oluştur
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. ADIM: Güncel UserModel'i oluştur (Artık UID parametresi almıyor)
      final newUser = UserModel(
        fullName: _nameController.text.trim(),
        username: _userController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        birthDate: _bdayController.text.trim(),
        gender: _selectedGender,
        focusAreas: [], // Odak alanları 5 adımlı sayfalarda doldurulacak
      );

      // 3. ADIM: Firestore'a kaydet
      // toMap() fonksiyonu artık veritabanında 'uid: null' oluşturmayacak
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());

      // 4. ADIM: Müzik kataloğunu seed'le (auth artık aktif)
      await SeedService.runSeedIfNeeded();

      if (mounted) {
        Navigator.pop(context); // Yükleniyor dairesini kapat

        // 5. ADIM: Ana sayfaya yönlendir
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint("Kayıt Hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt başarısız: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final primaryColor = theme.primaryColor;
    
    // Temaya göre giriş kutularının arka planını ayarla
    final inputFillColor = theme.brightness == Brightness.dark 
        ? Colors.white.withOpacity(0.05) 
        : Colors.black.withOpacity(0.05);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'MOYA', 
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.5)
            ),
            Text(
              'Zihinsel yolculuğuna başla', 
              style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12)
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hesap Oluştur', style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Ücretsiz başla, istediğin zaman iptal et', style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 14)),
                const SizedBox(height: 32),

                // AD SOYAD (Sadece harf kısıtlamalı)
                _buildTextField(
                  label: 'AD SOYAD',
                  hint: 'Adın ve soyadın',
                  controller: _nameController,
                  theme: theme,
                  textColor: textColor,
                  inputFillColor: inputFillColor,
                  formatters: [
                    LengthLimitingTextInputFormatter(40),
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZğüşıöçĞÜŞİÖÇ\s]')),
                  ],
                  validator: (val) => val!.trim().isEmpty ? 'Boş bırakılamaz' : null,
                ),

                // KULLANICI ADI
                _buildTextField(
                  label: 'KULLANICI ADI',
                  hint: 'Kullanıcı adın',
                  controller: _userController,
                  theme: theme,
                  textColor: textColor,
                  inputFillColor: inputFillColor,
                  validator: (val) => val!.trim().isEmpty ? 'Boş bırakılamaz' : null,
                ),

                // E-POSTA (Format kontrollü)
                _buildTextField(
                  label: 'E-POSTA',
                  hint: 'ornek@email.com',
                  controller: _emailController,
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  theme: theme,
                  textColor: textColor,
                  inputFillColor: inputFillColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'E-posta boş bırakılamaz';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Geçerli bir e-posta girin';
                    return null;
                  },
                ),

                // TELEFON (Sadece rakam)
                _buildTextField(
                  label: 'TELEFON',
                  hint: '05XX XXX XX XX',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  theme: theme,
                  textColor: textColor,
                  inputFillColor: inputFillColor,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (val) => val!.trim().isEmpty ? 'Boş bırakılamaz' : null,
                ),

                // ŞİFRE (Göz butonlu ve güvenlik kontrollü)
                _buildTextField(
                  label: 'ŞİFRE',
                  hint: 'En az 8 karakter',
                  controller: _passwordController,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  theme: theme,
                  textColor: textColor,
                  inputFillColor: inputFillColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Şifre boş bırakılamaz';
                    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z]).{8,}$').hasMatch(value)) {
                      return 'En az 8 karakter, 1 büyük ve 1 küçük harf içermelidir';
                    }
                    return null;
                  },
                ),

                // DOĞUM TARİHİ & CİNSİYET (Yan yana)
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'DOĞUM TARİHİ',
                        hint: 'GG.AA.YYYY',
                        controller: _bdayController,
                        icon: Icons.calendar_today_outlined,
                        keyboardType: TextInputType.datetime,
                        theme: theme,
                        textColor: textColor,
                        inputFillColor: inputFillColor,
                        formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        validator: (val) => val!.trim().isEmpty ? 'Boş olamaz' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(theme, textColor, inputFillColor),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),

                // YOLCULUĞA BAŞLA BUTONU
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, 
                      foregroundColor: theme.colorScheme.onPrimary, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Yolculuğa Başla 🚀', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),

                // GİRİŞ YAP YÖNLENDİRMESİ
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text.rich(
                      TextSpan(
                        text: 'Zaten hesabın var mı? ',
                        style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Giriş Yap', 
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // DİNAMİK TEXTFIELD TASARIMI
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ThemeData theme,
    required Color textColor,
    required Color inputFillColor,
    IconData? icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: theme.primaryColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: isPassword ? obscureText : false,
            keyboardType: keyboardType,
            inputFormatters: formatters,
            validator: validator,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: textColor.withOpacity(0.3), fontSize: 14),
              filled: true,
              fillColor: inputFillColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              // Şifre alanıysa tıklanabilir göz ikonu, değilse sabit ikon
              suffixIcon: isPassword 
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: textColor.withOpacity(0.4),
                        size: 20,
                      ),
                      onPressed: onToggleVisibility,
                      splashRadius: 24,
                    )
                  : (icon != null ? Icon(icon, color: textColor.withOpacity(0.4), size: 20) : null),
              errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  // DİNAMİK DROPDOWN TASARIMI
  Widget _buildDropdownField(ThemeData theme, Color textColor, Color inputFillColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CİNSİYET',
            style: TextStyle(color: theme.primaryColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            dropdownColor: theme.cardColor,
            icon: Icon(Icons.keyboard_arrow_down, color: textColor.withOpacity(0.4)),
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: inputFillColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            items: _genders.map((String item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: (val) => setState(() => _selectedGender = val!),
          ),
        ],
      ),
    );
  }
}