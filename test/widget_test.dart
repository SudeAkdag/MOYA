import 'package:flutter_test/flutter_test.dart';
import 'package:moya/main.dart';

void main() {
  testWidgets('MOYA Giriş Ekranı Temel Testi', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    expect(find.text('MOYA'), findsOneWidget);
    expect(find.text('E-posta'), findsOneWidget);
  });
}
