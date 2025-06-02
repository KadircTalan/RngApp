import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'drawer.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget content;

  const BasePage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        centerTitle: false,
        automaticallyImplyLeading: true,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }
}
