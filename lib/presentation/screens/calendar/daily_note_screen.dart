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

    setState(() {
      _isLoading = true;
    });

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
          const SnackBar(content: Text('Not başarıyla kaydedildi!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        title: const Text('Günlük Not Ekle'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bugünkü Ruh Halin (1-10)', style: theme.textTheme.titleMedium),
            Slider(
              value: _moodValue,
              min: 1,
              max: 10,
              divisions: 9,
              label: _moodValue.round().toString(),
              onChanged: (value) => setState(() => _moodValue = value),
            ),
            const SizedBox(height: 24),
            Text('Bugünkü Enerjin (1-10)', style: theme.textTheme.titleMedium),
            Slider(
              value: _energyValue,
              min: 1,
              max: 10,
              divisions: 9,
              label: _energyValue.round().toString(),
              onChanged: (value) => setState(() => _energyValue = value),
            ),
            const SizedBox(height: 24),
            Text('Notların', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Bugün nasıl geçtiğini, neler hissettiğini yazabilirsin...',
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                    : const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}