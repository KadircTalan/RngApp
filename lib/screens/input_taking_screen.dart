import "package:flutter/material.dart";
import "package:rng/screens/random_generator_screen.dart";
import "../custom_app_bar.dart";
import "../drawer.dart";

class InputTakingScreen extends StatefulWidget {
  const InputTakingScreen({super.key});

  @override
  State<InputTakingScreen> createState() => _InputTakingScreenState();
}

class _InputTakingScreenState extends State<InputTakingScreen> {
  int min = 0, max = 0;
  String? errorMessage;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Değer Aralığı Seç",
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextFormWidget(
                  labelTextData: "Minimum değer",
                  onSavedFunction: (val) => min = val,
                ),
                const SizedBox(height: 12),
                MyTextFormWidget(
                  labelTextData: "Maksimum değer",
                  onSavedFunction: (val) => max = val,
                ),
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
          if (formKey.currentState?.validate() == true) {
            formKey.currentState?.save();

            if (max < min) {
              setState(() {
                errorMessage = "Min ve Max değerleri hatalı";
              });

              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  errorMessage = null;
                });
              });
              return;
            }

            // --- ROUTINGİ DEĞİŞTİRİYORUZ ---
            Navigator.pushNamed(
              context,
              '/random',
              arguments: {'min': min, 'max': max},
            );
          }
        },
        backgroundColor: Colors.amber[700],
        child: const Icon(Icons.calculate),
      ),
    );
  }
}

class MyTextFormWidget extends StatelessWidget {
  final String labelTextData;
  final void Function(int val) onSavedFunction;

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
          return "Boş bırakılmaz";
        }
        if (int.tryParse(value) == null) {
          return "Geçerli bir sayı giriniz";
        }

        String numericPart = value.replaceAll("-", "");
        if (numericPart.length > 10) {
          return "Değerler maksimum 10 basamaklı olabilir";
        }
        return null;
      },
      keyboardType: TextInputType.number,
      onSaved: (newVal) => onSavedFunction(int.parse(newVal!)),
    );
  }
}
