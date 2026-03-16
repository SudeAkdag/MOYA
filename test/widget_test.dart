import 'package:flutter_test/flutter_test.dart';
import 'package:moya/main.dart';
import 'package:moya/core/theme/app_theme.dart'; // AppThemeType için gerekli

void main() {
  testWidgets('MOYA Giriş Ekranı Temel Testi', (WidgetTester tester) async {
    // Uygulamayı başlatıyoruz 
    // initialTheme parametresini buraya ekledik:
    await tester.pumpWidget(const MyApp(
      isLoggedIn: false, 
      initialTheme: AppThemeType.ocean, // Test için varsayılan bir tema verdik
    ));

    // Ekranda "MOYA" yazısının olduğunu doğruluyoruz
    expect(find.text('MOYA'), findsOneWidget);

    // Ekranda "E-posta" etiketinin olduğunu doğruluyoruz
    expect(find.text('E-posta'), findsOneWidget);
  });
}