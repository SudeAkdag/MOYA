import 'package:flutter_test/flutter_test.dart';
import 'package:moya/main.dart';

void main() {
  testWidgets('MOYA Giriş Ekranı Temel Testi', (WidgetTester tester) async {
    // Uygulamayı başlatıyoruz (isLoggedIn: false çünkü login ekranını test edeceğiz)
    await tester.pumpWidget(const MyApp(isLoggedIn: false));

    // Ekranda "MOYA" yazısının olduğunu doğruluyoruz
    expect(find.text('MOYA'), findsOneWidget);

    // Ekranda "E-posta" etiketinin olduğunu doğruluyoruz
    expect(find.text('E-posta'), findsOneWidget);

    // Sayaç testi olmadığı için eski '0' ve '1' kontrollerini siliyoruz
    // Çünkü senin ekranında artık bir sayaç yok.
  });
}