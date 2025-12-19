import 'package:flutter/material.dart';
import '../gui/home_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final pages = const [
    HomeScreen(),
    Placeholder(), // Categories
    Placeholder(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _CustomBottomBar(
        currentIndex: currentIndex,
        onChange: (i) => setState(() => currentIndex = i),
      ),
    );
  }
}

class _CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChange;

  const _CustomBottomBar({
    required this.currentIndex,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _dockItem(Icons.home, 0),
            _dockItem(Icons.category, 1),
            _dockItem(Icons.person, 2),
          ],
        ),
      ),
    );
  }

  Widget _dockItem(IconData icon, int index) {
    final selected = currentIndex == index;

    return GestureDetector(
      onTap: () => onChange(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(selected ? 14 : 10),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF2A9D8F)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: selected ? 30 : 24,
          color: selected ? Colors.white : Colors.grey,
        ),
      ),
    );
  }
}
