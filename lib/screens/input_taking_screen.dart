import "package:flutter/material.dart";
import "../custom_app_bar.dart";
import "../drawer.dart";
import 'package:rng/global_range.dart';  // GlobalRange ekledik

// Değer aralığı (min/max) alan ekran
class InputTakingScreen extends StatefulWidget {
  const InputTakingScreen({super.key});

  @override
  State<InputTakingScreen> createState() => _InputTakingScreenState();
}

class _InputTakingScreenState extends State<InputTakingScreen> {
  String? errorMessage; // Hata mesajı için değişken

  final formKey = GlobalKey<FormState>(); // Form için anahtar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Değer Aralığı Seç",
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      drawer: const CustomDrawer(), // Menü çekmecesi
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Minimum değer için input alanı
                MyTextFormWidget(
                  labelTextData: "Minimum değer",
                  onSavedFunction: (val) => GlobalRange.min = val,  // global min değişkenini güncelliyoruz
                ),
                const SizedBox(height: 12),
                // Maksimum değer için input alanı
                MyTextFormWidget(
                  labelTextData: "Maksimum değer",
                  onSavedFunction: (val) => GlobalRange.max = val,  // global max değişkenini güncelliyoruz
                ),
                // Hata mesajı varsa göster
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Form validasyonunu kontrol et
          if (formKey.currentState?.validate() == true) {
            formKey.currentState?.save();

            // Min ve Max değerleri mantık kontrolü
            if (GlobalRange.max < GlobalRange.min) {
              setState(() {
                errorMessage = "Min ve Max değerleri hatalı";
              });

              // Hata mesajını 1 saniye sonra temizle
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  errorMessage = null;
                });
              });
              return;
            }

            // Min ve Max değerleri parametre olarak gönderip random sayıya yönlendir
            Navigator.pushNamed(
              context,
              '/random',
              arguments: {'min': GlobalRange.min, 'max': GlobalRange.max},  // global değerleri route ile yolluyoruz
            );
          }
        },
        backgroundColor: Colors.amber[700],
        child: const Icon(Icons.calculate),
      ),
    );
  }
}

/// Tekrar eden TextFormField widget'ı.
/// Label ve onSaved fonksiyonu parametre olarak veriliyor.
/// Her yerde ayrı ayrı kod yazmak yerine, tekrar kullanıma uygun yapı.
class MyTextFormWidget extends StatelessWidget {
  final String labelTextData;  // Label için yazı
  final void Function(int val) onSavedFunction; // Değeri kaydeden fonksiyon

  const MyTextFormWidget({
    super.key,
    required this.labelTextData,
    required this.onSavedFunction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelTextData,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Boş bırakılmaz"; // Boşsa uyarı
        }
        if (int.tryParse(value) == null) {
          return "Geçerli bir sayı giriniz"; // Sayı değilse uyarı
        }

        // Negatif işareti kaldırıp rakam uzunluğunu kontrol et
        String numericPart = value.replaceAll("-", "");
        if (numericPart.length > 10) {
          return "Değerler maksimum 10 basamaklı olabilir"; // Büyük değer uyarısı
        }
        return null;
      },
      keyboardType: TextInputType.number, // Sadece sayı klavyesi gelsin
      onSaved: (newVal) => onSavedFunction(int.parse(newVal!)), // Değeri dışarıya aktar
    );
  }
}
