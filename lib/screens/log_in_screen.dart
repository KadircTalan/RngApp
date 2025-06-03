import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_app_bar.dart';
import 'package:rng/database/user_database.dart';
import 'package:rng/services/shared_preferences_service.dart';

// Giriş ekranı (LoginScreen)
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Kullanıcıdan e-posta ve şifre almak için controller'lar
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;      // Hata mesajı gösterimi için değişken
  bool _isLoggingIn = false;  // Giriş yapılırken butonu pasif yapar

  // Ekran açılır açılmaz son giriş yapılan e-posta'yı yükle
  @override
  void initState() {
    super.initState();
    _loadLastEmail();
  }

  // SharedPreferences'tan son giriş yapılan e-posta'yı oku ve input'a yaz
  Future<void> _loadLastEmail() async {
    String? lastEmail = await SharedPreferencesService.getLastEmail();
    if (lastEmail != null && lastEmail.isNotEmpty) {
      _emailController.text = lastEmail;
    }
  }

  // Asenkron giriş fonksiyonu
  Future<void> _login() async {
    setState(() {
      _isLoggingIn = true;  // "Giriş yapılıyor..." göstergesi için
      _errorMessage = null; // Önceki hataları temizle
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Firebase ile giriş işlemi (bulut tarafı)
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kullanıcıyı yerel veritabanında doğrula (offline/check)
      Map<String, dynamic>? user = await UserDatabase().validateUser(email, password);

      if (user != null) {
        // Map'i düzenlenebilir hale getiriyoruz, uid ekliyoruz
        user = Map<String, dynamic>.from(user);
        user['uid'] = userCredential.user?.uid;

        // SharedPreferences'a kullanıcı bilgisini kaydet (kalıcı oturum vs. için)
        await SharedPreferencesService.saveUser(user);

        // SON GİRİŞ YAPAN E-POSTA'YI KAYDET!
        await SharedPreferencesService.saveLastEmail(email);

        print("Giriş yapan kullanıcı:");
        print(user);

        // Widget dispose olmuş mu kontrolü, yoksa ekranda hata çıkar.
        if (!mounted) return;

        // Giriş başarılı uyarısı (Snackbar)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Giriş Başarılı!'),
            duration: Duration(seconds: 1),
          ),
        );

        // Snackbar'ın 1 sn gösterilmesini bekle
        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

        // Girişten sonra "input" ekranına yönlendir
        Navigator.pushReplacementNamed(context, '/input');
      } else {
        // Eğer kullanıcı veritabanında yoksa hata ver
        setState(() {
          _errorMessage = "Kullanıcı yerel veritabanında bulunamadı!";
          _isLoggingIn = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      // Firebase hatalarını yönet (kullanıcı yok, yanlış şifre vs.)
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
      // Beklenmeyen başka bir hata varsa...
      setState(() {
        _errorMessage = 'Bilinmeyen hata: $e';
        _isLoggingIn = false;
      });
    }
  }

  // Ekran tasarımı burada başlar.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Giriş Yap",
        centerTitle: false,
        automaticallyImplyLeading: false, // Geri tuşu gözükmesin
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Ortala
          children: [
            // E-posta girişi
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-posta'),
            ),
            const SizedBox(height: 10),
            // Şifre girişi
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true, // Şifreyi gizle
            ),
            const SizedBox(height: 20),
            // Hata mesajı varsa göster
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 10),
            // Giriş butonu (yükleniyorsa buton pasif ve loading göster)
            ElevatedButton(
              onPressed: _isLoggingIn ? null : _login,
              child: _isLoggingIn
                  ? const CircularProgressIndicator()
                  : const Text('Giriş Yap'),
            ),
            const SizedBox(height: 20),
            // Kayıt olma yönlendirmesi
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
