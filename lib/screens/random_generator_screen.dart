import 'package:flutter/material.dart';
import 'dart:math';
import '../drawer.dart';

class RandomGeneratorScreen extends StatefulWidget {
  final int min, max;

  const RandomGeneratorScreen({super.key, required this.min, required this.max});

  @override
  State<RandomGeneratorScreen> createState() => _RandomGeneratorScreenState();
}

class _RandomGeneratorScreenState extends State<RandomGeneratorScreen> {
  late int min = widget.min;
  late int max = widget.max;

  int? _genratedNum;
  final generateAnum = Random();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Rastgele Sayı Üretici",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.06,
            ),
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              ElevatedButton(
                onPressed: () {
                  setState(() {
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
                      style: TextStyle(fontSize: screenWidth * 0.05,color: Colors.yellow),
                    ),
                  ],
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
