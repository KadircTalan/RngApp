import 'package:flutter/material.dart';
import '../screens/log_in_screen.dart';
import '../utils/global_range.dart';
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  // Çıkış yapmadan önce kullanıcıya onay soran dialog
  Future<bool> _showLogoutConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Çıkış'),
              content: const Text('Çıkmak istediğinize emin misiniz?'),
              actions: [
                TextButton(
                  child: const Text('İptal'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text('Evet'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false; // Dialog kapanırsa false döner
  }

  // Çıkış işlemini yapan fonksiyon
  void _logout(BuildContext context) async {
    bool confirm = await _showLogoutConfirmation(context);
    if (confirm) {
      Navigator.pop(context); // Drawer'ı kapat

      // Login ekranına geçiş yap (sayfa yığını temizlenebilir)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      // Çıkış yapıldığını kullanıcıya bildir
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Çıkış yapıldı')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Üst logo/görsel alanı, responsive yükseklik
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Image.network(
              "https://allgoodgreat.com/wp-content/uploads/2021/08/satunnaislukugeneraattori.png",
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),

          // Profil sayfasına navigasyon
          ListTile(
            title: const Text('Profil'),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),

          // Değer aralığı seçme sayfasına navigasyon
          ListTile(
            title: const Text('Değer Aralığı Seç'),
            leading: const Icon(Icons.tune),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/input');
            },
          ),

          // Sayı üretme sayfasına navigasyonu
          // GlobalRange sınıfını import et
          ListTile(
            title: const Text('Sayı Üret'),
            leading: const Icon(Icons.casino),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/random',
                arguments: {'min': GlobalRange.min, 'max': GlobalRange.max},
              );
            },
          ),

          const Spacer(), // Alt kısımda çıkış butonu için boşluk bırak
          // Oturumdan çıkış butonu
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Oturumdan Ayrıl'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
