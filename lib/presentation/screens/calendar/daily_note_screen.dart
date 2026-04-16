import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moya/data/services/calendar_service.dart';

class DailyNoteScreen extends StatefulWidget {
  final DateTime selectedDate;

  const DailyNoteScreen({super.key, required this.selectedDate});

  @override
  State<DailyNoteScreen> createState() => _DailyNoteScreenState();
}

class _DailyNoteScreenState extends State<DailyNoteScreen> {
  double _moodValue = 5.0;
  double _energyValue = 5.0;
  final _noteController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveNote() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final data = {
        'date': Timestamp.fromDate(widget.selectedDate),
        'mood': _moodValue,
        'energy': _energyValue,
        'note': _noteController.text,
      };

      await CalendarService.addDailyEntry(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Başarıyla kaydedildi'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Günlük Not'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RUH HALİ
            _buildThemedSlider(
              title: 'Ruh Hali',
              value: _moodValue,
              theme: theme,
              onChanged: (val) => setState(() => _moodValue = val),
            ),
            const SizedBox(height: 20),
            
            // ENERJİ
            _buildThemedSlider(
              title: 'Enerji Seviyesi',
              value: _energyValue,
              theme: theme,
              onChanged: (val) => setState(() => _energyValue = val),
            ),
            const SizedBox(height: 32),

            Text('Günün Özeti', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // ÇERÇEVELİ TEXTFIELD
            TextField(
              controller: _noteController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Düşüncelerini buraya yazabilirsin...',
                filled: true,
                fillColor: theme.colorScheme.surface,
                // Çerçeveyi görünür kılan kısım:
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading 
                  ? CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.onPrimary) 
                  : const Text('Kaydet', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemedSlider({
    required String title,
    required double value,
    required ThemeData theme,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        // Kartın etrafındaki çerçeve:
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                value.round().toString(),
                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              activeTrackColor: theme.colorScheme.primary,
              inactiveTrackColor: theme.colorScheme.primary.withOpacity(0.1),
              thumbColor: theme.colorScheme.primary,
              overlayColor: theme.colorScheme.primary.withOpacity(0.1),
              // Slider içindeki noktaları (divisions) daha belirgin yapmak için:
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
            ),
            child: Slider(
              value: value,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}