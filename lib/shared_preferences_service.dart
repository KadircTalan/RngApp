import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Kullanıcı verilerini kaydet
  static Future<void> saveUser(Map<String, dynamic> user) async {
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

  // Kullanıcı verilerini oku (örnek)
  static Future<Map<String, String>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('email') ?? '',
      'password': prefs.getString('password') ?? '',
      'name': prefs.getString('name') ?? '',
      'surname': prefs.getString('surname') ?? '',
      'birthDate': prefs.getString('birthDate') ?? '',
      'birthPlace': prefs.getString('birthPlace') ?? '',
      'currentCity': prefs.getString('currentCity') ?? '',
      'current_user': prefs.getString('current_user') ?? '',
      'uid': prefs.getString('uid') ?? '',
    };
  }

  // İstersen logout için kullanıcı verilerini temizleme fonksiyonu da ekleyebilirsin
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('name');
    await prefs.remove('surname');
    await prefs.remove('birthDate');
    await prefs.remove('birthPlace');
    await prefs.remove('currentCity');
    await prefs.remove('current_user');
    await prefs.remove('uid');
  }
}
