import 'package:flutter/material.dart';
import 'gui/main_layout.dart';
import 'utils/token_store.dart';
import 'utils/user_store.dart';
import 'utils/auth_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔐 TOKEN + USER RESTORE
  final token = await TokenStore.read();
  final user = await UserStore.read();

  if (token != null && token.isNotEmpty && user != null) {
    authState.value = true;
    userSession.value = user;
  } else {
    authState.value = false;
    userSession.value = null;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainLayout(),
    );
  }
}
