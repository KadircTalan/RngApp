import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rng/custom_app_bar.dart';
import 'package:rng/user_database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  String? _selectedBirthPlace;
  String? _selectedCurrentCity;
  String? _errorMessage;

  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;

  final List<int> days = List.generate(31, (index) => index + 1);
  final List<int> months = List.generate(12, (index) => index + 1);
  final List<int> years = List.generate(DateTime.now().year - 1900 + 1, (index) => DateTime.now().year - index);

  final List<String> _cities = [
    'İstanbul','Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Amasya', 'Ankara', 'Antalya',
    'Artvin', 'Aydın', 'Balıkesir', 'Bilecik', 'Bingöl', 'Bitlis', 'Bolu',
    'Burdur', 'Bursa', 'Çanakkale', 'Çankırı', 'Çorum', 'Denizli', 'Diyarbakır',
    'Edirne', 'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir', 'Gaziantep',
    'Giresun', 'Gümüşhane', 'Hakkâri', 'Hatay', 'Isparta', 'Mersin',
    'İzmir', 'Kars', 'Kastamonu', 'Kayseri', 'Kırklareli', 'Kırşehir', 'Kocaeli',
    'Konya', 'Kütahya', 'Malatya', 'Manisa', 'Kahramanmaraş', 'Mardin',
    'Muğla', 'Muş', 'Nevşehir', 'Niğde', 'Ordu', 'Rize', 'Sakarya', 'Samsun',
    'Siirt', 'Sinop', 'Sivas', 'Tekirdağ', 'Tokat', 'Trabzon', 'Tunceli',
    'Şanlıurfa', 'Uşak', 'Van', 'Yozgat', 'Zonguldak', 'Aksaray', 'Bayburt',
    'Karaman', 'Kırıkkale', 'Batman', 'Şırnak', 'Bartın', 'Ardahan', 'Iğdır',
    'Yalova', 'Karabük', 'Kilis', 'Osmaniye', 'Düzce'
  ];

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

  Future<void> _signUp() async {
    setState(() => _errorMessage = null);

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String name = _nameController.text.trim();
    String surname = _surnameController.text.trim();
    String? birthPlace = _selectedBirthPlace;
    String? currentCity = _selectedCurrentCity;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty ||
        name.isEmpty || surname.isEmpty ||
        selectedDay == null || selectedMonth == null || selectedYear == null ||
        birthPlace == null || currentCity == null) {
      setState(() => _errorMessage = "Tüm alanları doldurun!");
      return;
    }

    if (password != confirmPassword) {
      setState(() => _errorMessage = "Şifreler eşleşmiyor!");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String birthDate = '${selectedDay.toString().padLeft(2, '0')}-${selectedMonth.toString().padLeft(2, '0')}-${selectedYear.toString()}';

      Map<String, dynamic> user = {
        'email': email,
        'password': password,
        'name': name,
        'surname': surname,
        'birthDate': birthDate,
        'birthPlace': birthPlace,
        'currentCity': currentCity,
        'uid': userCredential.user?.uid,
      };

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'name': name,
        'surname': surname,
        'birthDate': birthDate,
        'birthPlace': birthPlace,
        'currentCity': currentCity,
      });

      await UserDatabase().insertUser(user);
      await _saveToSharedPreferences(user);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Başarıyla kayıt olundu!'),
          duration: Duration(seconds: 1),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _errorMessage = 'Bu e-posta zaten kullanılıyor.';
        } else if (e.code == 'invalid-email') {
          _errorMessage = 'Geçersiz e-posta adresi.';
        } else if (e.code == 'weak-password') {
          _errorMessage = 'Şifre çok zayıf.';
        } else {
          _errorMessage = 'Kayıt sırasında hata oluştu: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Bilinmeyen hata: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Kayıt Ol',
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
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
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Şifre (Tekrar)'),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'İsim'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _surnameController,
                decoration: const InputDecoration(labelText: 'Soyisim'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Gün'),
                      value: selectedDay,
                      items: days.map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(),
                      onChanged: (val) => setState(() => selectedDay = val),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Ay'),
                      value: selectedMonth,
                      items: months.map((m) => DropdownMenuItem(value: m, child: Text('$m'))).toList(),
                      onChanged: (val) => setState(() => selectedMonth = val),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Yıl'),
                      value: selectedYear,
                      items: years.map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
                      onChanged: (val) => setState(() => selectedYear = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Doğum Yeri'),
                value: _selectedBirthPlace,
                items: _cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBirthPlace = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Yaşadığı İl'),
                value: _selectedCurrentCity,
                items: _cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCurrentCity = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _signUp,
                child: const Text('Kayıt Ol'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  'Zaten üye misiniz? Giriş Yapın',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
