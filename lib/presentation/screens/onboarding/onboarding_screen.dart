import 'package:flutter/material.dart';
import 'package:moya/data/services/user_service.dart';

import 'package:moya/presentation/screens/main_wrapper.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
// Alt widget'ları kendi dosyalarından import ediyoruz
import 'widgets/step_reasons.dart';
import 'widgets/step_experience.dart';
import 'widgets/step_time.dart';
import 'widgets/step_routine.dart';
import 'widgets/step_theme.dart';

class OnboardingScreen extends StatefulWidget {
  final Map<String, dynamic> initialUserData;

  const OnboardingScreen({super.key, required this.initialUserData});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 1;
  final int _totalSteps = 5;
  late Map<String, dynamic> _finalData;

  @override
  void initState() {
    super.initState();
    _finalData = Map.from(widget.initialUserData);
    _finalData.addAll({
      'selectedGoals': <String>[],
      'experienceLevel': '',
      'dailyTime': '',
      'routines': <String>[],
      'selectedTheme': 'nature',
      'onboardingCompleted': false,
    });
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    } else {
      _saveAndFinish();
    }
  }

  void _saveAndFinish() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    _finalData['onboardingCompleted'] = true;

 try {
    await UserService().saveUserToFirestore(_finalData);

    // 🔑 YENİ: Giriş yapıldığını kaydet ki uygulama bir sonraki açılışta Login'e dönmesin
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    // 🚀 DÜZELTME: HomeScreenNew yerine MainWrapper'a yönlendiriyoruz
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainWrapper()),
      (route) => false,
    );
  } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata oluştu: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStepContent(),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${_currentStep}. ADIM / $_totalSteps",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
              const Text("MOYA",
                  style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: _currentStep / _totalSteps,
            borderRadius: BorderRadius.circular(10),
            minHeight: 6,
            backgroundColor: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1: return StepReasons(data: _finalData);
      case 2: return StepExperience(data: _finalData);
      case 3: return StepTime(data: _finalData);
      case 4: return StepRoutine(data: _finalData);
      case 5: return StepTheme(data: _finalData);
      default: return const SizedBox();
    }
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // GERİ BUTONU: 1. adımdaysa kayıt sayfasına döner, değilse bir önceki adıma geçer.
          IconButton(
            onPressed: () {
              if (_currentStep > 1) {
                setState(() => _currentStep--);
              } else {
                Navigator.pop(context); // Kayıt sayfasına geri döner
              }
            },
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.all(15),
            ),
          ),
          
          _currentStep == 5
              ? ElevatedButton(
                  onPressed: _saveAndFinish,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text("TAMAMLA"),
                )
              : ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
        ],
      ),
    );
  }
}