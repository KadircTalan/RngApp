import 'package:flutter/material.dart';
import 'custom_app_bar.dart';  // Özel AppBar bileşeni
import 'drawer.dart';         // Uygulama genelinde kullanılan Drawer menüsü

/// Ortak sayfa yapısı.
/// Başlık ve içerik alır, Scaffold içinde gösterir.
class BasePage extends StatelessWidget {
  final String title;     // Sayfa başlığı
  final Widget content;   // Sayfanın asıl içeriği

  const BasePage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Özel app bar kullanılıyor, başlık parametre olarak geliyor
      appBar: CustomAppBar(
        title: title,
        centerTitle: false,
        automaticallyImplyLeading: true,  // Geri butonu gösterilebilir
      ),
      // Uygulama genelinde ortak kullanılan drawer
      drawer: const CustomDrawer(),
      // Sayfa içeriği padding ile sarılıyor
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }
}
