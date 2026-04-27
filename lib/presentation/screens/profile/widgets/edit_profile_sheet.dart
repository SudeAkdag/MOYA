import 'package:flutter/material.dart';

class EditProfileSheet extends StatefulWidget {
  final Map<String, dynamic> currentData;
  final Function(Map<String, dynamic> newData) onSave;

  const EditProfileSheet({super.key, required this.onSave, required this.currentData});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bdayController;

  String? _selectedGender;
  List<String> _selectedGoals = [];

  final List<String> _allGoals = [
    'Stres & Kaygı', 
    'Odaklanma', 
    'Uyku Kalitesi', 
    'Motivasyon'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentData['name']);
    _usernameController = TextEditingController(text: widget.currentData['username']);
    _emailController = TextEditingController(text: widget.currentData['email']);
    _phoneController = TextEditingController(text: widget.currentData['phone']);
    _bdayController = TextEditingController(text: widget.currentData['bday']);
    _selectedGender = widget.currentData['gender'];
    _selectedGoals = List<String>.from(widget.currentData['selectedGoals'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    // Tüm renkleri ve fontları buradan çekiyoruz
    final theme = Theme.of(context);
    

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20, right: 20, top: 20,
      ),
      decoration: BoxDecoration(
        // AppThemes'deki background rengini kullanır
        color: theme.scaffoldBackgroundColor, 
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Profili Düzenle", 
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
              )
            ),
            const SizedBox(height: 20),

            _buildTextField("Ad Soyad", _nameController, theme),
            _buildTextField("Kullanıcı Adı", _usernameController, theme),
            _buildTextField("E-posta", _emailController, theme),
            _buildTextField("Telefon Numarası", _phoneController, theme, keyboardType: TextInputType.phone),
            _buildTextField("Doğum Tarihi", _bdayController, theme),

            const SizedBox(height: 16),
            _buildLabel("Cinsiyet", theme),
            _buildGenderDropdown(theme),

            const SizedBox(height: 20),
            _buildLabel("Odak Alanların", theme),
            _buildFocusAreas(theme),

            const SizedBox(height: 30),
            ElevatedButton(
              // Buton stili zaten AppThemes'deki elevatedButtonTheme'den geliyor
              onPressed: () {
                widget.onSave({
                  'name': _nameController.text,
                  'username': _usernameController.text,
                  'email': _emailController.text,
                  'phone': _phoneController.text,
                  'bday': _bdayController.text,
                  'gender': _selectedGender,
                  'selectedGoals': _selectedGoals,
                });
                Navigator.pop(context);
              },
              child: const Center(child: Text("GÜNCELLE")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, ThemeData theme, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          filled: true,
          // Kart yüzeyi (surface) rengini hafif şeffaf kullanarak derinlik katıyoruz
          fillColor: theme.colorScheme.surface.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), 
            borderSide: BorderSide.none
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.primaryColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(ThemeData theme) {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      dropdownColor: theme.colorScheme.surface,
      style: TextStyle(color: theme.colorScheme.onSurface),
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surface.withOpacity(0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      items: ['Kadın', 'Erkek', 'Belirtmek İstemiyorum']
          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
          .toList(),
      onChanged: (val) => setState(() => _selectedGender = val),
    );
  }

  Widget _buildFocusAreas(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _allGoals.map((goal) {
        final isSelected = _selectedGoals.contains(goal);
        return FilterChip(
          label: Text(goal),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              selected ? _selectedGoals.add(goal) : _selectedGoals.remove(goal);
            });
          },
          // Seçili rengi temanın primary rengi yapar
          selectedColor: theme.primaryColor,
          checkmarkColor: Colors.white,
          backgroundColor: theme.colorScheme.surface.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(
            color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.1)
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text, 
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
          fontWeight: FontWeight.bold
        )
      ),
    );
  }
}