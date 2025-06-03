import 'package:flutter/material.dart';
import 'dart:math';
import '../custom_app_bar.dart';
import '../drawer.dart';
import 'package:rng/global_range.dart';  // GlobalRange ekledik

class RandomGeneratorScreen extends StatefulWidget {
  // Parametre olarak min ve max almaya gerek kalmadı, çünkü globalden okunacak

  const RandomGeneratorScreen({super.key});

  @override
  State<RandomGeneratorScreen> createState() => _RandomGeneratorScreenState();
}

class _RandomGeneratorScreenState extends State<RandomGeneratorScreen> {
  // Global değerlerden alıyoruz
  late int min = GlobalRange.min;
  late int max = GlobalRange.max;

  int? _genratedNum; // Üretilen rastgele sayı
  final generateAnum = Random(); // Random nesnesi

  @override
  Widget build(BuildContext context) {
    // Ekran ölçüleri responsive için
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Rastgele Sayı Üretici",
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: true,
      ),
      drawer: const CustomDrawer(),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Üretilmiş sayı veya başlangıç mesajı gösterimi
              Text(
                _genratedNum?.toString() ?? "Sayı Üretmek İçin Butona Bas",
                style: TextStyle(
                  fontSize: _genratedNum == null ? screenWidth * 0.08 : screenWidth * 0.10,
                  fontWeight: FontWeight.bold,
                  color: _genratedNum == null ? Colors.black54 : Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.05),

              // Sayı üretme butonu
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Global min-max aralığında random sayı üretimi
                    _genratedNum = min + generateAnum.nextInt(max - min + 1);
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.15,
                    vertical: screenHeight * 0.02,
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_task_rounded, color: Colors.white),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'ÜRET',
                      style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.yellow),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Min-Max değerlerinin gösterildiği kart
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.blueGrey.shade50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.tune, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Text(
                            'Değer Aralığı',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Global min ve max değer gösterimi
                      Text(
                        'Min: $min   •   Max: $max',
                        style: const TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
