import 'package:dio/dio.dart';
import 'dart:convert';
import '../utils/token_store.dart';
import '../utils/user_store.dart';

const String baseUrl = "http://92.249.61.58:8080/";

/// =====================================================
/// MODELLER
/// =====================================================

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json["id"].toString()),
      name: json["name"] ?? "",
    );
  }
}

class Product {
  final int id;
  final int categoryId;
  final String name;
  final String imageUrl;
  final String price;
  final String description;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawImage = json["image_url"]?.toString() ?? "";

    return Product(
      id: int.parse(json["id"].toString()),
      categoryId: int.parse(json["category_id"].toString()),
      name: json["name"] ?? "Ürün",
      imageUrl: rawImage.isEmpty
          ? ""
          : rawImage.startsWith("http")
          ? rawImage
          : "http://92.249.61.58$rawImage",
      price: json["price"]?.toString() ?? "0",
      description: json["description"]?.toString() ?? "",
    );
  }
}

class Review {
  final String userName;
  final double rating;
  final String comment;
  final String date;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json["user_name"] ?? "Anonim",
      rating: double.tryParse(json["rating"]?.toString() ?? "0") ?? 0,
      comment: json["comment"] ?? "",
      date: json["date"] ?? "",
    );
  }
}

class Seller {
  final int id;
  final String name;
  final String phone;
  final double rating;

  Seller({
    required this.id,
    required this.name,
    required this.phone,
    required this.rating,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: int.parse(json["id"].toString()),
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      rating: double.tryParse(json["rating"]?.toString() ?? "5") ?? 5,
    );
  }
}

class ProductDetailResponse {
  final bool success;
  final Product product;
  final List<String> images;
  final List<Review> reviews;
  final Seller? seller;

  ProductDetailResponse({
    required this.success,
    required this.product,
    required this.images,
    required this.reviews,
    required this.seller,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      success: json["success"] == true,
      product: Product.fromJson(json["product"]),
      images: (json["images"] as List? ?? []).map((e) => e.toString()).toList(),
      reviews: (json["reviews"] as List? ?? [])
          .map((e) => Review.fromJson(e))
          .toList(),
      seller: json["seller"] != null ? Seller.fromJson(json["seller"]) : null,
    );
  }
}

class SearchResponse {
  final List<Category> categories;
  final List<Product> products;

  SearchResponse({required this.categories, required this.products});

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

class LoginResponse {
  final bool success;
  final String token;
  final Map<String, dynamic> user;

  LoginResponse({
    required this.success,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["success"] == true,
      token: json["token"] ?? "",
      user: json["user"] ?? {},
    );
  }
}

class RegisterResponse {
  final bool success;
  final String message;
  final String token;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.token,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json["success"] == true,
      message: json["message"] ?? "",
      token: json["token"] ?? "",
    );
  }
}

class Address {
  final int id;
  final String fullName;
  final String phone;
  final String addressLine;
  final String district;
  final String city;

  Address({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    required this.district,
    required this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: int.parse(json["id"].toString()),
      fullName: json["full_name"] ?? "",
      phone: json["phone"] ?? "",
      addressLine: json["address_line"] ?? "",
      district: json["district"] ?? "",
      city: json["city"] ?? "",
    );
  }
}

/// =====================================================
/// API SERVICE
/// =====================================================

class ApiService {
  final Dio _dio;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      ) {
    // 🔐 JWT INTERCEPTOR
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStore.read();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
  }

  /// 🔑 STRING / MAP SAFE DECODER
  Map<String, dynamic> _asMap(dynamic data) {
    if (data == null) return <String, dynamic>{};
    if (data is String) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return Map<String, dynamic>.from(data as Map);
  }

  Future<bool> addAddress({
    required String fullName,
    required String phone,
    required String addressLine,
    required String district,
    required String city,
  }) async {
    try {
      await _dio.post(
        "/add_address",
        data: {
          "full_name": fullName,
          "phone": phone,
          "address_line": addressLine,
          "district": district,
          "city": city,
        },
      );

      // 🔥 Exception yoksa = başarılı
      return true;
    } catch (e) {
      return false;
    }
  }

  /// ---------------- AUTH ----------------

  Future<List<Address>> getAddresses() async {
    try {
      final res = await _dio.get("/get_addresses");
      final data = _asMap(res.data);

      if (data["success"] == true) {
        final list = (data["addresses"] as List? ?? []);
        return list.map((e) => Address.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<LoginResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        "/login",
        data: {"email": email, "password": password},
      );

      final data = _asMap(res.data);
      return LoginResponse.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAddons() async {
    try {
      final res = await _dio.get("/get_addons");

      if (res.data == null || res.data.toString().trim().isEmpty) {
        print("❌ getAddons: EMPTY RESPONSE");
        return [];
      }

      final data = res.data is String ? jsonDecode(res.data) : res.data;

      if (data["success"] != true) {
        print("❌ getAddons failed: $data");
        return [];
      }

      return List<Map<String, dynamic>>.from(data["addons"]);
    } catch (e) {
      print("❌ getAddons error: $e");
      return [];
    }
  }

  Future<bool> createOrder({
    required int addressId,
    required String productName,
    required double price,
    required double totalPrice,
    required String appointment,
    required String addons,
  }) async {
    try {
      final res = await _dio.post(
        "/create_order",
        data: {
          "address_id": addressId,
          "product_name": productName,
          "price": price,
          "total_price": totalPrice,
          "appointment_datetime": appointment,
          "addons": addons,
        },
      );
      return res.data["success"] == true;
    } catch (_) {
      return false;
    }
  }

  Future<RegisterResponse?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        "/register",
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "phone": phone,
          "password": password,
          "role": "ALICI",
        },
      );

      final data = _asMap(res.data);
      return RegisterResponse.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final token = await TokenStore.read();

    final res = await _dio.put(
      "/update_profile",
      options: Options(headers: {"Authorization": "Bearer $token"}),
      data: {"name": name, "email": email, "phone": phone},
    );

    final data = _asMap(res.data);
    return data["success"] == true;
  }

  /// ---------------- DATA ----------------

  Future<List<Category>> getCategories() async {
    final res = await _dio.get("/get_categories");
    final data = _asMap(res.data);

    if (data["success"] == true) {
      final list = (data["categories"] as List? ?? []);
      return list.map((e) => Category.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<Product>> getProducts(int categoryId) async {
    final res = await _dio.get(
      "/get_products",
      queryParameters: {"category_id": categoryId},
    );

    final data = _asMap(res.data);

    if (data["success"] == true) {
      final list = (data["products"] as List? ?? []);
      return list.map((e) => Product.fromJson(e)).toList();
    }
    return [];
  }

  Future<ProductDetailResponse?> getProductDetail(int productId) async {
    try {
      final res = await _dio.get(
        "/get_product_detail",
        queryParameters: {"id": productId},
      );

      final data = _asMap(res.data);

      if (data["success"] == true) {
        return ProductDetailResponse.fromJson(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<SearchResponse?> search(String query) async {
    final res = await _dio.get("/search", queryParameters: {"q": query});

    final data = _asMap(res.data);

    if (data["success"] == true) {
      return SearchResponse.fromJson(data);
    }
    return null;
  }
}
