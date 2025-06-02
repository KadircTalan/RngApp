import 'package:flutter/material.dart';
import 'package:rng/base_page.dart';
import 'package:rng/user_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('current_user');  // current_user artık email
    print("Giriş yapan kullanıcı: $email");
    if (email != null) {
      final data = await UserDatabase().getUser(email);  // email ile sorgula
      print("Bulunan user: $data");
      setState(() {
        user = data;
        loading = false;
      });
    } else {
      setState(() {
        user = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Profil Sayfası',
      content: loading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? const Center(
        child: Text(
          "Kullanıcı bilgisi bulunamadı!",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _infoTile(Icons.person, 'E-posta', user!['email']), // Burada userdb’de hala 'username' kullanıyorsan bunu email diye değiştir.
                _infoTile(Icons.badge, 'İsim', user!['name']),
                _infoTile(Icons.family_restroom, 'Soyisim', user!['surname']),
                _infoTile(Icons.calendar_today, 'Doğum Tarihi', user!['birthDate']),
                _infoTile(Icons.location_city, 'Doğum Yeri', user!['birthPlace']),
                _infoTile(Icons.home, 'Yaşadığı İl', user!['currentCity']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(label),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
