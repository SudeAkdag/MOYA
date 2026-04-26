import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 🚀 HATA DÜZELTME: context.read için gerekli
import 'package:moya/core/theme/app_theme.dart'; // 🚀 HATA DÜZELTME: AppThemeType için gerekli
import 'package:moya/core/theme/bloc/theme_bloc.dart'; // 🚀 HATA DÜZELTME: ThemeBloc için gerekli
import 'package:moya/core/theme/bloc/theme_event.dart'; // 🚀 HATA DÜZELTME: ChangeThemeEvent için gerekli
import 'package:moya/presentation/screens/onboarding/steps/goal_step.dart';
import '../auth/register/register_screen.dart';
import 'steps/experience_step.dart';
import 'steps/time_step.dart';
import 'steps/routine_step.dart';
import 'steps/theme_step.dart';
import '../../../data/services/user_service.dart';
import '../main_wrapper.dart'; 

class PersonalizationWrapper extends StatefulWidget {
  final Map<String, dynamic> initialData;
  const PersonalizationWrapper({super.key, required this.initialData});

  @override
  State<PersonalizationWrapper> createState() => _PersonalizationWrapperState();
}

class _PersonalizationWrapperState extends State<PersonalizationWrapper> {
  final PageController _pageController = PageController();
  final UserService _userService = UserService();
  int _currentStep = 0;

  // --- VERİLER ---
  String? _goal;
  String? _experienceLevel;
  String? _time;
  List<String> _selectedRoutines = [];
  String? _theme;

  // 🚀 HATA DÜZELTME: Ekran görüntüsündeki ilk hatayı çözen metot tanımı
 AppThemeType _mapIdToThemeType(String id) {
  switch (id) {
    case 'ocean': return AppThemeType.ocean;
    case 'forest': return AppThemeType.nature;
    case 'galaxy': return AppThemeType.purple;
    case 'clouds': return AppThemeType.pink;
    case 'earth': return AppThemeType.brown;
    case 'night': return AppThemeType.night; // 👈 Gece modunu buraya da ekle
    default: return AppThemeType.nature;
  }
}

  void _nextPage() {
    if (_currentStep < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400), 
        curve: Curves.easeInOut
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400), 
        curve: Curves.easeInOut
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen()),
        (route) => false,
      );
    }
  }

void _finishOnboarding() async {
    try {
      // 1. Yükleme dairesini göster
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
        ),
      );

      // 2. Verileri topla
      final Map<String, dynamic> finalUserData = {
        // Register sayfasından gelen veriler (name, phone, bday vb.)
        ...widget.initialData, 
        
        // Onboarding süreci boyunca seçilen veriler
        'primaryGoal': _goal,           // List<String>
        'experienceLevel': _experienceLevel, // List<String> 
        'dailyTime': _time,             // String
        'routines': _selectedRoutines,  // List<String>
        'selectedTheme': _theme,        // String
        'onboardingCompleted': true,
      };

      // 3. UserService üzerinden kaydet
      // DİKKAT: _userService() değil, _userService şeklinde kullanıyoruz
      await _userService.saveUserToFirestore(finalUserData);

      if (mounted) {
        Navigator.pop(context); // Loading dairesini kapat
        
        // 4. Ana sayfaya uçur
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Hata olursa loading'i kapat
      debugPrint("Kritik Hata: $e");
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Veriler kaydedilemedi: $e"), 
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          _previousPage();
          return false;
        },
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (i) => setState(() => _currentStep = i),
          children: [
            // ADIM 1: Hedef
            GoalStep(
              onSelect: (list) { 
                setState(() { _goal = list.join(", "); });
                _nextPage(); 
              },
              onBack: _previousPage,
            ),
            // ADIM 2: Deneyim
            ExperienceStep(
              onSelect: (val) { 
                setState(() { _experienceLevel = val; });
                _nextPage(); 
              },
              onBack: _previousPage,
            ),
            // ADIM 3: Vakit
            TimeStep(
              onSelect: (val) { _time = val; _nextPage(); },
              onBack: _previousPage,
            ),
            // ADIM 4: Rutin
            RoutineStep(
              onSelect: (list) { _selectedRoutines = list; _nextPage(); },
              onBack: _previousPage,
            ),
            // ADIM 5: Tema
            ThemeStep(
              onSelect: (val) { 
                _theme = val; 
                
                // 🚀 HATA DÜZELTME: Importlar eklenince 'read' ve 'ChangeThemeEvent' tanınacak
                final themeType = _mapIdToThemeType(val);
                context.read<ThemeBloc>().add(ChangeThemeEvent(themeType));
                
                _finishOnboarding(); 
              },
              onBack: _previousPage,
            ),
          ],
        ),
      ),
    );
  }
}