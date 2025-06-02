import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../custom_app_bar.dart';
import 'package:rng/user_database.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoggingIn = false;

  Future<void> _saveToSharedPreferences(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', user['email'] ?? '');
    await prefs.setString('password', user['password'] ?? '');
    await prefs.setString('name', user['name'] ?? '');
    await prefs.setString('surname', user['surname'] ?? '');
    await prefs.setString('birthDate', user['birthDate'] ?? '');
    await prefs.setString('birthPlace', user['birthPlace'] ?? '');
    await prefs.setString('currentCity', user['currentCity'] ?? '');
    await prefs.setString('current_user', user['email'] ?? '');

    if (user['uid'] != null) {
      await prefs.setString('uid', user['uid']);
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoggingIn = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Map<String, dynamic>? user = await UserDatabase().validateUser(email, password);

      if (user != null) {
        // UID'yi Firebase'den alıp kullanıcı verisine ekle
        user['uid'] = userCredential.user?.uid;

        await _saveToSharedPreferences(user);

        print("Giriş yapan kullanıcı:");
        print(user);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Giriş Başarılı!'),
            duration: Duration(seconds: 1),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, '/input');
      } else {
        setState(() {
          _errorMessage = "Kullanıcı yerel veritabanında bulunamadı!";
          _isLoggingIn = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'Kullanıcı bulunamadı.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Yanlış şifre.';
        } else {
          _errorMessage = 'Giriş sırasında hata oluştu: ${e.message}';
        }
        _isLoggingIn = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Bilinmeyen hata: $e';
        _isLoggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Giriş Yap",
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-posta'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoggingIn ? null : _login,
              child: _isLoggingIn
                  ? const CircularProgressIndicator()
                  : const Text('Giriş Yap'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                'Henüz üye değil misiniz? Kayıt Olun',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
