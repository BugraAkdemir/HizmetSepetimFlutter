import 'package:flutter/material.dart';
import '../appData/api_service.dart';
import '/theme/colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final String name;
  final String price;
  final String description;
  final String imageUrl;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ApiService api = ApiService();
  late Future<ProductDetailResponse?> future;

  @override
  void initState() {
    super.initState();
    future = api.getProductDetail(widget.productId);
  }

  String _safe(String? v, {String fallback = "-"}) {
    final s = (v ?? "").trim();
    return s.isEmpty ? fallback : s;
  }

  String _img(String? raw) {
    final s = (raw ?? "").trim();
    if (s.isEmpty) return "";
    if (s.startsWith("http")) return s;
    if (s.startsWith("/")) return "http://92.249.61.58$s";
    return "http://92.249.61.58/$s";
  }

  Widget _placeholder() {
    return Container(
      color: primary.withOpacity(0.10),
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: primary,
          size: 42,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        foregroundColor: textDark,
        title: Text(_safe(widget.name, fallback: "Ürün")),
      ),
      body: FutureBuilder<ProductDetailResponse?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          final detail = snapshot.data;
          if (detail == null || detail.success != true) {
            return const Center(
              child: Text(
                "Ürün bilgileri alınamadı",
                style: TextStyle(color: textSoft),
              ),
            );
          }

          final product = detail.product;
          final images = detail.images.map(_img).where((e) => e.isNotEmpty).toList();
          final fallbackImage = _img(widget.imageUrl);
          final heroImage =
              images.isNotEmpty ? images.first : fallbackImage;

          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(bottom: 110),
                children: [
                  // ================= HERO =================
                  Container(
                    height: 260,
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: heroImage.isEmpty
                          ? _placeholder()
                          : Image.network(
                              heroImage,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= INFO CARD =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _safe(product.name),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "₺${_safe(product.price)}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _safe(
                              product.description,
                              fallback:
                                  "Bu ürün için henüz bir açıklama girilmemiş.",
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: textSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ================= BUY BAR =================
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: primary,
                  ),
                  child: const Center(
                    child: Text(
                      "Satın Al (Yakında)",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
