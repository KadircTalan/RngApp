import 'package:flutter/material.dart';
// Firebase temel paketi importu
import 'package:firebase_core/firebase_core.dart';
import 'package:rng/database/user_database.dart';
// Firebase CLI ile otomatik oluşturulan ayar dosyası
import 'firebase_options.dart';
// Farklı ekranları import ediyoruz
import 'package:rng/screens/log_in_screen.dart';
import 'package:rng/screens/sign_up_screen.dart';
import 'package:rng/screens/profile_page.dart';
import 'package:rng/screens/input_taking_screen.dart';
import 'package:rng/screens/random_generator_screen.dart';
import 'package:rng/utils/global_range.dart';  // GlobalRange eklendi

// Uygulama giriş noktası, Firebase ve SQLite başlatılıyor.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SQLite'daki kullanıcılar konsola basılıyor (debug amaçlı)
  List<Map<String, dynamic>> users = await UserDatabase().getAllUsers();
  print("SQLite'daki tüm kullanıcılar:");
  for (var user in users) {
    print(user);
  }

  runApp(const MyApp());
}

// Kök widget - uygulamanın asıl çatısı
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Sağ üstteki debug banner'ını kaldırır
      initialRoute: '/login',            // Uygulama açıldığında ilk açılacak ekran

      // Kısa yol (route) isimlerine göre ekranlar burada eşleniyor
      routes: {
        '/login': (context) => const LoginScreen(),           // Giriş ekranı
        '/signup': (context) => const SignUpScreen(),         // Kayıt ekranı
        '/profile': (context) => const ProfilePage(),         // Profil ekranı
        '/input': (context) => const InputTakingScreen(),     // Değer aralığı seçme ekranı
      },

      // Daha dinamik ve parametreli yönlendirmeler için (örnek: RandomGeneratorScreen)
      onGenerateRoute: (settings) {
        // '/random' route'una geldiğinde artık global aralığı kullanacağız, argüman beklemiyoruz
        if (settings.name == '/random') {
          return MaterialPageRoute(
            builder: (context) => const RandomGeneratorScreen(),
          );
        }
        // Bilinmeyen route gelirse null döner (yani hata ekranı yok)
        return null;
      },
    );
  }
}
