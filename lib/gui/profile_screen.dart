import 'package:flutter/material.dart';
import '../utils/token_store.dart';
import '../utils/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "👤 Profilim",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await TokenStore.clear();
              authState.value = false;
            },
            child: const Text("Çıkış Yap"),
          )
        ],
      ),
    );
  }
}
