import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moya/data/services/calendar_service.dart';
import 'package:moya/presentation/screens/E&M/widgets/breathing_screen/breathing_pacer.dart';
import 'package:moya/presentation/screens/E&M/widgets/breathing_screen/breathing_technique_card.dart';
import 'package:moya/presentation/screens/E&M/widgets/breathing_screen/breathing_technique_model.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with TickerProviderStateMixin {

  late final AnimationController _controller;

  Timer? _timer;

  int _sessionTime = 60; // Default to 1 minute

  int _remainingTime = 60;

  bool _isPlaying = false;

  int _currentPhaseIndex = 0;

  int _phaseRemainingTime = 0;



  final List<int> _durations = [1, 3, 5]; // Available durations in minutes



  late BreathingTechnique _selectedTechnique;



  final List<BreathingTechnique> _techniques = [

    const BreathingTechnique(

      title: "Kutu Nefesi (4-4-4-4)",

      subtitle: "Sınav öncesi zihni toparla",

      duration: "5 dk",

      tag: "Odaklanma",

      color: Colors.orange,

      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCFtbal5YrjiXvO8see1DK3HkaA9Gl5AOLsa9d7PnBapTVwCrSVwYoego0j3gLmVREoNVMigzPK0Fm39V4Hz7tF28K8bRDDg38n9w4_VelQI67QfFVNulIdY75nxO2qFCGBu6Hl9Q84KYz4nzfe-w9PtSC4sEmR-eJcA04pzsf4VZ0rCVOsXP9eQtT1xBWFmCOTXQJNt-exMuAFwNfQuIi7UGuz_vVwFKRPuTiTeo2HaYAZd79XKUJyB7zJiDSZcri8Cop0-u0XH9h1",

      phases: [

        BreathingPhase(instruction: "Nefes Al", duration: 4),

        BreathingPhase(instruction: "Tut", duration: 4),

        BreathingPhase(instruction: "Nefes Ver", duration: 4),

        BreathingPhase(instruction: "Tut", duration: 4),

      ],

    ),

    const BreathingTechnique(

      title: "4-7-8 Tekniği",

      subtitle: "Hızlıca uykuya dalış",

      duration: "3 dk",

      tag: "Uyku",

      color: Colors.blue,

      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCkRaVdm927JcpwWo3aaUb1DpyCQ9BAiGQDLq3g9gSlGbOnTBqcUgIqlHQKs-ZTl2_gTWjXSANISbYETiS3F6w-yl0iXxg9lyFsT5RTPEas-sf8iS4d1QrqRbfxj90Wc5uv-fW0_fPaIRjpI1opml0uSyDEFIp9xPY3MgZK0gXv7HKXc4uHnUsj_T4-LCyNQrCcKnQlCbzqsYOtR2OEVbtZLDkzWpPzAPDXxSYXtnDAHyB4RVNcAHALQt1DLUQakzYSG27TMithkBFk",

      phases: [

        BreathingPhase(instruction: "Nefes Al", duration: 4),

        BreathingPhase(instruction: "Tut", duration: 7),

        BreathingPhase(instruction: "Nefes Ver", duration: 8),

      ],

    ),

    const BreathingTechnique(

      title: "Sakinleştirici Nefes",

      subtitle: "Anksiyete ve stres anı",

      duration: "2 dk",

      tag: "Panik",

      color: Colors.green,

      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDb3WgufuxI9_vas7klPz4AruC9Y-8kqGAThestgHgSVVYH757JbT8mRxyYzjZwzIPEBcVl54XL4iwuA2Ug4LCBjL5DZnbE_UY-kXZaf05RL9RAyUC-yZHKg3CdKN1VkPh_mMjvYoj3kHP_LS5jJSix75q6HEwpPvFra5ut2vf5A_MGR95z9UlBV4ADqs0TTJQfvPY2V3_X4tXfeJNIMC-HgA_3YQAyb43xV_enrud5JTD93REilkMmRSP1NTGlQ_46TomZYHXaVSB6",

      phases: [

        BreathingPhase(instruction: "Nefes Al", duration: 4),

        BreathingPhase(instruction: "Nefes Ver", duration: 6),

      ],

    ),

  ];



  @override

  void initState() {

    super.initState();

    _selectedTechnique = _techniques.first;

    _phaseRemainingTime = _selectedTechnique.phases.first.duration;



    _controller = AnimationController(

      vsync: this,

      duration: Duration(seconds: _selectedTechnique.phases.first.duration),

    )..addListener(() {

        setState(() {});

      });

  }



  @override

  void dispose() {

    _controller.dispose();

    _timer?.cancel();

    super.dispose();

  }



  void _onTechniqueSelected(BreathingTechnique technique) {

    setState(() {

      _selectedTechnique = technique;

      _resetTimer();

    });

  }



  void _onDurationSelected(int minutes) {

    setState(() {

      _sessionTime = minutes * 60;

      _resetTimer();

    });

  }



  void _togglePlayPause() {

    setState(() {

      _isPlaying = !_isPlaying;

      if (_isPlaying) {

        _startTimer();

      } else {

        _pauseTimer();

      }

    });

  }



  void _startTimer() {

    _controller.forward(from: _controller.value);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {

      if (_remainingTime > 0) {

        setState(() {

          _remainingTime--;

          _phaseRemainingTime--;

          if (_phaseRemainingTime <= 0) {

            _currentPhaseIndex = (_currentPhaseIndex + 1) % _selectedTechnique.phases.length;

            final newPhase = _selectedTechnique.phases[_currentPhaseIndex];

            _phaseRemainingTime = newPhase.duration;

            _controller.duration = Duration(seconds: newPhase.duration);

            _controller.forward(from: 0);

          }

        });

      } else {

        _finishSession();

      }

    });

  }



  void _pauseTimer() {

    _timer?.cancel();

    _controller.stop();

  }



  void _resetTimer() {

    _timer?.cancel();

    _controller.reset();

    setState(() {

      _isPlaying = false;

      _remainingTime = _sessionTime;

      _currentPhaseIndex = 0;

      final firstPhase = _selectedTechnique.phases.first;

      _phaseRemainingTime = firstPhase.duration;

      _controller.duration = Duration(seconds: firstPhase.duration);

    });

  }



  Future<void> _incrementBreathingExerciseCount() async {

    final today = DateTime.now();

    final startOfToday = DateTime(today.year, today.month, today.day);



    final query = await FirebaseFirestore.instance

        .collection('calendar')

        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)

        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))

        .where('date', isLessThan: Timestamp.fromDate(startOfToday.add(const Duration(days: 1))))

        .limit(1)

        .get();



    if (query.docs.isNotEmpty) {

      final docId = query.docs.first.id;

      await FirebaseFirestore.instance.collection('calendar').doc(docId).update({

        'completedBreathingExercises': FieldValue.increment(1),

      });

    } else {

      await CalendarService.addDailyEntry({

        'date': Timestamp.fromDate(startOfToday),

        'completedBreathingExercises': 1,

      });

    }

  }



  void _finishSession() {

    _resetTimer();

    _incrementBreathingExerciseCount();

    // Show a dialog or a snackbar to notify the user

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(content: Text('Nefes egzersizi tamamlandı!')),

    );

  }



  @override

  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final currentPhase = _selectedTechnique.phases[_currentPhaseIndex];



    return Scaffold(

      appBar: _buildAppBar(context),

      body: ListView(

        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),

        children: [

          const SizedBox(height: 24),

          BreathingPacer(

            pacerText: _isPlaying ? currentPhase.instruction : "Hazır",

            pacerSubText: _isPlaying ? '$_phaseRemainingTime saniye' : "Başlamak için dokun",

            controller: _controller,

          ),

          const SizedBox(height: 48),

          _buildControls(),

          const SizedBox(height: 48),

          _buildTechniquesList(theme),

        ],

      ),

    );

  }



  PreferredSizeWidget _buildAppBar(BuildContext context) {

    final theme = Theme.of(context);

    return PreferredSize(

      preferredSize: const Size.fromHeight(60.0),

      child: ClipRRect(

        child: BackdropFilter(

          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),

          child: AppBar(

            backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.85),

            leading: IconButton(

              icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onBackground),

              onPressed: () => Navigator.of(context).pop(),

            ),

            title: Text("Nefes Egzersizleri", style: theme.textTheme.titleLarge),

            centerTitle: true,

            actions: [

              IconButton(

                icon: Icon(Icons.bar_chart, color: theme.colorScheme.onBackground, size: 28),

                onPressed: () {},

              ),

              const SizedBox(width: 8),

            ],

            elevation: 0,

          ),

        ),

      ),

    );

  }



  Widget _buildControls() {
    final theme = Theme.of(context);
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    final timeString = '$minutes:$seconds';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text("SÜRE", style: theme.textTheme.labelSmall),
            const SizedBox(height: 4),
            PopupMenuButton<int>(
              onSelected: _onDurationSelected,
              itemBuilder: (BuildContext context) {
                return _durations.map((int minutes) {
                  return PopupMenuItem<int>(
                    value: minutes,
                    child: Text('$minutes dakika'),
                  );
                }).toList();
              },
              child: Row(
                children: [
                  Text(timeString, style: theme.textTheme.titleLarge),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: theme.colorScheme.onPrimary,
              size: 38,
            ),
          ),
        ),
        Column(
          children: [
            Text("MOD", style: theme.textTheme.labelSmall),
            const SizedBox(height: 4),
            Text(_selectedTechnique.tag, style: theme.textTheme.titleMedium?.copyWith(color: _selectedTechnique.color)),
          ],
        ),
      ],
    );
  }



  Widget _buildTechniquesList(ThemeData theme) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Padding(

          padding: const EdgeInsets.only(left: 4.0, bottom: 16),

          child: Text("Teknikler", style: theme.textTheme.headlineSmall),

        ),

        ..._techniques.map((technique) => BreathingTechniqueCard(

              technique: technique,

              isSelected: technique.title == _selectedTechnique.title,

              onTap: () => _onTechniqueSelected(technique),

            )),

      ],

    );

  }

}
