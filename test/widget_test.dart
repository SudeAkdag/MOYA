import 'package:flutter_test/flutter_test.dart';
import 'package:moya/main.dart';
import 'package:moya/core/theme/app_theme.dart'; // 🚀 AppThemeType için bu importu ekleyin

void main() {
  testWidgets('MOYA Giriş Ekranı Temel Testi', (WidgetTester tester) async {
    // 🚀 initialTheme parametresini buraya ekledik
    await tester.pumpWidget(const MyApp(
      isLoggedIn: false, 
      initialTheme: AppThemeType.nature, 
    ));

    expect(find.text('MOYA'), findsOneWidget);
    // Eğer LoginScreen içinde "E-posta" metni bir TextField label'ı ise 
    // find.text yerine find.byWidgetPredicate kullanmanız gerekebilir 
    // ama temel widget kontrolü için bu yeterlidir.
    expect(find.text('E-posta'), findsOneWidget);
  });
}