import 'package:dio/dio.dart';

const String baseUrl = "http://92.249.61.58:8080/";

// ===================== MODELLER =====================

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json["id"].toString()), // 🔥 KRİTİK
      name: json["name"] ?? "",
    );
  }
}

class Product {
  final int id;
  final String name;
  final String imageUrl;
  final String price;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
  final rawImage = json["image_url"]?.toString() ?? "";

  final imageUrl = rawImage.isEmpty
      ? ""
      : rawImage.startsWith("http")
          ? rawImage
          : "http://92.249.61.58$rawImage"; // 🔥 BACKEND’E UYARLAMA

  return Product(
    id: int.parse(json["id"].toString()),
    name: json["name"]?.toString() ?? "Ürün",
    imageUrl: imageUrl,
    price: json["price"]?.toString() ?? "0",
    description: json["description"]?.toString() ?? "",
  );
}

}

class SearchResponse {
  final List<Category> categories;
  final List<Product> products;

  SearchResponse({
    required this.categories,
    required this.products,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      categories: (json["categories"] as List? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),
      products: (json["products"] as List? ?? [])
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}

// ===================== API SERVICE =====================

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Accept": "application/json",
        },
      ),
    );
  }

  // -------- KATEGORİLER --------
  Future<List<Category>> getCategories() async {
    final res = await _dio.get("get_categories");

    if (res.data != null && res.data["success"] == true) {
      return (res.data["categories"] as List)
          .map((e) => Category.fromJson(e))
          .toList();
    }
    return [];
  }

  // -------- ÜRÜNLER --------
 Future<List<Product>> getProducts(int categoryId) async {
  final res = await _dio.get(
    "get_products",
    queryParameters: {
      "category_id": categoryId.toString(),
    },
  );

  if (res.data != null && res.data["success"] == true) {
    final list = res.data["products"];

    if (list == null) {
      return []; // 🔥 ürün yok → boş liste
    }

    return (list as List)
        .map((e) => Product.fromJson(e))
        .toList();
  }

  return [];
}


  // -------- ARAMA --------
  Future<SearchResponse?> search(String query) async {
    final res = await _dio.get(
      "search",
      queryParameters: {"q": query},
    );

    if (res.data != null && res.data["success"] == true) {
      return SearchResponse.fromJson(res.data);
    }
    return null;
  }
}
