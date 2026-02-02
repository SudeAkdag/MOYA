import 'package:flutter/material.dart';

class EditProfileSheet extends StatefulWidget {
  final Map<String, dynamic> currentData;
  final Function(Map<String, dynamic> newData) onSave;

  const EditProfileSheet({super.key, required this.onSave, required this.currentData});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  // Metin Alanları için Kontrolcüler
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bdayController;

  // Seçim Alanları
  String? _selectedGender;
  List<String> _selectedFocusAreas = [];

  final List<String> _allFocusAreas = ['Stres Yönetimi', 'Uyku Kalitesi', 'Odaklanma', 'Anksiyete', 'Özgüven', 'Mutluluk'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentData['name']);
    _usernameController = TextEditingController(text: widget.currentData['username']);
    _emailController = TextEditingController(text: widget.currentData['email']);
    _phoneController = TextEditingController(text: widget.currentData['phone']);
    _bdayController = TextEditingController(text: widget.currentData['bday']);
    _selectedGender = widget.currentData['gender'];
    _selectedFocusAreas = List<String>.from(widget.currentData['focusAreas'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20, right: 20, top: 20,
      ),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text("Profili Düzenle", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            const SizedBox(height: 20),

            _buildTextField("Ad Soyad", _nameController),
            _buildTextField("Kullanıcı Adı", _usernameController),
            _buildTextField("E-posta", _emailController),
            _buildTextField("Telefon Numarası", _phoneController, keyboardType: TextInputType.phone),
            _buildTextField("Doğum Tarihi", _bdayController),

            const SizedBox(height: 16),
            _buildLabel("Cinsiyet"),
            _buildGenderDropdown(theme),

            const SizedBox(height: 16),
            _buildLabel("Odak Alanların"),
            _buildFocusAreas(theme),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                widget.onSave({
                  'name': _nameController.text,
                  'username': _usernameController.text,
                  'email': _emailController.text,
                  'phone': _phoneController.text,
                  'bday': _bdayController.text,
                  'gender': _selectedGender,
                  'focusAreas': _selectedFocusAreas,
                });
                Navigator.pop(context);
              },
              child: const Text("Güncelle"),
            ),
          ],
        ),
      ),
    );
  }

  // Yardımcı Widget: Metin Girişleri
  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Yardımcı Widget: Cinsiyet Seçimi
  Widget _buildGenderDropdown(ThemeData theme) {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      items: ['Kadın', 'Erkek', 'Belirtmek İstemiyorum']
          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
          .toList(),
      onChanged: (val) => setState(() => _selectedGender = val),
    );
  }

  // Yardımcı Widget: Tıklanabilir Odak Alanları (Chips)
  Widget _buildFocusAreas(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 0,
      children: _allFocusAreas.map((area) {
        final isSelected = _selectedFocusAreas.contains(area);
        return FilterChip(
          label: Text(area),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _selectedFocusAreas.add(area);
              } else {
                _selectedFocusAreas.remove(area);
              }
            });
          },
          selectedColor: theme.primaryColor.withOpacity(0.2),
          checkmarkColor: theme.primaryColor,
        );
      }).toList(),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white70)),
    );
  }
}