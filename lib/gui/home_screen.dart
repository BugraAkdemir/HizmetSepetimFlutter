import 'package:flutter/material.dart';
import '../appData/api_service.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const bg = Color(0xFFF2F6F5);
  static const primary = Color(0xFF2A9D8F);
  static const secondary = Color(0xFF52B788);
  static const textDark = Color(0xFF0F172A);
  static const textSoft = Color(0xFF64748B);

  final ApiService api = ApiService();

  List<Category> categories = [];
  Map<int, List<Product>> products = {};
  bool loading = true;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      errorText = null;
    });

    try {
      final cats = await api.getCategories();

      final results = await Future.wait(
        cats.map((c) async => MapEntry(c.id, await api.getProducts(c.id))),
      );

      final map = <int, List<Product>>{
        for (final e in results) e.key: e.value,
      };

      if (!mounted) return;
      setState(() {
        categories = cats;
        products = map;
        loading = false;
      });
    } catch (e) {
      debugPrint("HOME LOAD ERROR => $e");

      if (!mounted) return;
      setState(() {
        loading = false;
        errorText = "Veriler alınamadı. İnternet / API kontrol et.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: primary),
      );
    }

    if (errorText != null) {
      return Material(
        color: bg,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 44, color: primary),
                const SizedBox(height: 10),
                Text(
                  errorText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: textSoft, fontSize: 14),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _load,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Yeniden Dene",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Material(
      color: bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            const SizedBox(height: 12),
            _search(),
            const SizedBox(height: 20),
            _campaign(),
            const SizedBox(height: 28),
            ...categories.map(_category),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      "HizmetSepetim",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: textDark,
      ),
    );
  }

  Widget _search() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Ne arıyorsun?",
        hintStyle: const TextStyle(color: textSoft),
        prefixIcon: const Icon(Icons.search, color: primary),
        filled: true,
        fillColor: primary.withOpacity(0.08),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _campaign() {
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("🎉", style: TextStyle(fontSize: 30)),
          SizedBox(height: 6),
          Text(
            "Özel Kampanyalar",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Yakında burada olacak",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _category(Category c) {
    final list = products[c.id] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 26),
        Row(
          children: [
            Expanded(
              child: Text(
                c.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
            ),
            const Text(
              "Tümünü gör",
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          const Text(
            "Henüz ürün yok",
            style: TextStyle(color: textSoft),
          )
        else
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) => _card(list[i]),
            ),
          ),
      ],
    );
  }

  Widget _card(Product p) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(
              productId: p.id,
              name: p.name,
              price: p.price,
              description: p.description,
              imageUrl: p.imageUrl,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: _productImage(p.imageUrl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₺${p.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productImage(String url) {
    if (url.isEmpty) return _placeholder();

    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: primary,
            ),
          ),
        );
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: primary.withOpacity(0.08),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: primary,
          size: 36,
        ),
      ),
    );
  }
}
