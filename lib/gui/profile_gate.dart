import 'package:flutter/material.dart';
import '../utils/auth_state.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'profile_screen.dart';

class ProfileGate extends StatelessWidget {
  const ProfileGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: authState,
      builder: (context, loggedIn, _) {
        if (loggedIn) {
          return const ProfileScreen();
        }
        return const _GuestProfileView();
      },
    );
  }
}

class _GuestProfileView extends StatelessWidget {
  const _GuestProfileView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 👤 Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A9D8F).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 36,
                  color: Color(0xFF2A9D8F),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Hesabın yok veya giriş yapmadın",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Profilini görüntülemek ve işlemlerini yönetmek için giriş yap",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 24),

              // 🔑 Login
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A9D8F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Giriş Yap",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 📝 Signup
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: const BorderSide(
                      color: Color(0xFF2A9D8F),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Kayıt Ol",
                    style: TextStyle(
                      color: Color(0xFF2A9D8F),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
