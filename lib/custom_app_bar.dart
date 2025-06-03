import 'package:flutter/material.dart';

// Özel bir AppBar widget'ı.
// PreferredSizeWidget ile AppBar yüksekliği tanımlanabilir hale getirilir.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // AppBar'da gösterilecek başlık metni
  final String title;

  // Başlık ortalanacak mı?
  final bool centerTitle;

  // Otomatik olarak "geri" butonu gösterilsin mi?
  final bool automaticallyImplyLeading;

  // Arka plan rengi (opsiyonel)
  final Color? backgroundColor;

  // Constructor - zorunlu title, opsiyonel diğer parametreler
  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
    );
  }

  // AppBar'ın yüksekliği toolbar yüksekliği kadar (56.0)
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
