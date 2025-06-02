import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  // Firebase CLI ile oluşturulan dosya
import 'package:rng/screens/log_in_screen.dart';
import 'package:rng/screens/sign_up_screen.dart';
import 'package:rng/screens/profile_page.dart';
import 'package:rng/screens/input_taking_screen.dart';
import 'package:rng/screens/random_generator_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/profile': (context) => const ProfilePage(),
        '/input': (context) => const InputTakingScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/random') {
          final args = settings.arguments as Map<String, int>?;
          final min = args?['min'] ?? 0;
          final max = args?['max'] ?? 100;
          return MaterialPageRoute(
            builder: (context) => RandomGeneratorScreen(min: min, max: max),
          );
        }
        return null;
      },
    );
  }
}
