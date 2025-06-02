import 'package:flutter/material.dart';
import 'screens/log_in_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
        false;
  }

  void _logout(BuildContext context) async {
    bool confirm = await _showLogoutConfirmation(context);
    if (confirm) {
      Navigator.pop(context); // Drawer'ı kapat
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Çıkış yapıldı')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Image.network(
              "https://allgoodgreat.com/wp-content/uploads/2021/08/satunnaislukugeneraattori.png",
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          ListTile(
            title: const Text('Profil'),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            title: const Text('Değer Aralığı Seç'),
            leading: const Icon(Icons.tune),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/input');
            },
          ),
          ListTile(
            title: const Text('Sayı Üret'),
            leading: const Icon(Icons.casino),
            onTap: () {
              Navigator.pop(context);
              // Eğer parametre gönderilmiyorsa /random için hata çıkar
              // İstersen buraya default argüman verebiliriz
              Navigator.pushNamed(context, '/random', arguments: {'min': 0, 'max': 100});
            },
          ),
          const Spacer(),
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
