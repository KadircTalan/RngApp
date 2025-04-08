import 'package:flutter/material.dart';
import '/screens/input_taking_screen.dart';
import '/screens/log_in_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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

          // Value range selection
          ListTile(
            title: const Text('Değer Aralığı Seç'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputTakingScreen(),
                ),
              );
            },
          ),
          // Logout
          Spacer(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: const Text('Oturumdan Ayrıl'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
