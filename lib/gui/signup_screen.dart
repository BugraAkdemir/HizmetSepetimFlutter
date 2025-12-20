import 'package:flutter/material.dart';
import '../appData/api_service.dart';
import '../utils/token_store.dart';
import '../utils/auth_state.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final api = ApiService();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;

  Future<void> _register() async {
    setState(() => loading = true);

    final res = await api.register(
      firstName: nameCtrl.text.trim(),
      lastName: "-",
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      password: passCtrl.text,
    );

    if (!mounted) return;

    if (res != null && res.token.isNotEmpty) {
      await TokenStore.save(res.token);
      authState.value = true;
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kayıt başarısız")),
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

          // 🔙 Custom back button
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

          // 🔥 Signup card
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
                      "Hesabını Oluştur ✨",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "HizmetSepetim’e katıl, hizmetlere hemen ulaş",
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 28),

                    _input(nameCtrl, "Ad Soyad", Icons.person_outline),
                    _input(emailCtrl, "E-posta", Icons.mail_outline),
                    _input(phoneCtrl, "Telefon", Icons.phone_outlined),
                    _input(passCtrl, "Şifre", Icons.lock_outline, obscure: true),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: loading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A9D8F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Hesap Oluştur",
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
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Hesabın var mı? Giriş Yap",
                          style: TextStyle(
                            color: Color(0xFF2A9D8F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Center(
                      child: Text(
                        "Kayıt olarak kullanım şartlarını kabul etmiş olursun",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
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

  Widget _input(
    TextEditingController c,
    String label,
    IconData icon, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
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
      ),
    );
  }
}
