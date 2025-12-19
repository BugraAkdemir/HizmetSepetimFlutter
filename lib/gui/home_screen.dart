import 'package:flutter/material.dart';
import '../appData/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();

  List<Category> categories = [];
  Map<int, List<Product>> categoryProducts = {};

  bool isLoading = true;
  String? error;

  String query = "";
  SearchResponse? searchResult;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    loadCategoriesAndProducts();
  }

  Future<void> loadCategoriesAndProducts() async {
    try {
      categories = await api.getCategories();

      for (final c in categories) {
        final products = await api.getProducts(c.id);
        categoryProducts[c.id] = products;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(() => isLoading = false);
  }

  Future<void> onSearch(String text) async {
    setState(() => query = text);

    if (text.isEmpty) {
      setState(() => searchResult = null);
      return;
    }

    setState(() => isSearching = true);
    searchResult = await api.search(text);
    setState(() => isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 4,
        title: const Text("HizmetSepetim"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: "Ne arıyorsun?",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text("Hata: $error"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Banner
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB7E4C7), Color(0xFFA8D0E6)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("🎉", style: TextStyle(fontSize: 30)),
                          SizedBox(height: 6),
                          Text(
                            "Özel Kampanyalar",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Yakında burada olacak"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔹 Search Results
                  if (searchResult != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Arama Sonuçları",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...searchResult!.products.map(
                          (p) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.shopping_bag),
                              title: Text(p.name ?? "Ürün"),
                              subtitle: Text("₺${p.price}"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // 🔹 Categories + Products
                  ...categories.map((c) {
                    final products = categoryProducts[c.id] ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B4965),
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (products.isEmpty)
                          const Text(
                            "Henüz ürün yok",
                            style: TextStyle(color: Colors.grey),
                          )
                        else
                          SizedBox(
                            height: 190,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: products.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, i) {
                                final p = products[i];
                                return Container(
                                  width: 150,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: p.imageUrl.isEmpty
                                              ? const Icon(
                                                  Icons.image,
                                                  size: 40,
                                                )
                                              : Image.network(
                                                  p.imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return const Icon(
                                                          Icons.broken_image,
                                                          size: 40,
                                                        );
                                                      },
                                                ),
                                        ),
                                      ),

                                      const SizedBox(height: 8),
                                      Text(
                                        p.name ?? "Ürün",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "₺${p.price}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2A9D8F),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                        const SizedBox(height: 28),
                      ],
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
