import 'package:flutter/material.dart';
import '../appData/api_service.dart';
import '../utils/token_store.dart';
import '../utils/auth_state.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final api = ApiService();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;

  Future<void> _login() async {
    setState(() => loading = true);

    final res = await api.login(
      email: emailCtrl.text.trim(),
      password: passCtrl.text,
    );

    if (!mounted) return;

    if (res != null && res.token.isNotEmpty) {
      await TokenStore.save(res.token);
      authState.value = true;
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("E-posta veya şifre hatalı")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔥 Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2A9D8F),
                  Color(0xFF52B788),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🔙 Custom back button (iOS style)
          Positioned(
            top: 48,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          // 🔥 Login card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 25,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tekrar Hoş Geldin 👋",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "HizmetSepetim hesabına giriş yap",
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 32),

                    _input(
                      controller: emailCtrl,
                      label: "E-posta",
                      icon: Icons.mail_outline,
                    ),
                    const SizedBox(height: 16),
                    _input(
                      controller: passCtrl,
                      label: "Şifre",
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A9D8F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Giriş Yap",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Hesabın yok mu? Kayıt Ol",
                          style: TextStyle(
                            color: Color(0xFF2A9D8F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
