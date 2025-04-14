import 'package:http/http.dart' as http;
import 'dart:convert';

class Cat {
  final String id;
  final String url;
  final String? breedName;
  final String? breedDescription;
  final DateTime? likedAt;

  Cat({
    required this.id,
    required this.url,
    this.breedName,
    this.breedDescription,
    this.likedAt,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    final breed = json['breeds']?.isNotEmpty == true ? json['breeds'][0] : null;
    return Cat(
      id: json['id'],
      url: json['url'],
      breedName: breed?['name'],
      breedDescription: breed?['description'],
    );
  }

  static Cat getSecretCat() {
    return Cat(
      id: 'secret_cat',
      url: 'https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg',
      breedName: 'Secret Maine Coon',
      breedDescription: 'You found the Secret Cat after 10 likes!',
    );
  }
}

class CatApi {
  static Future<List<Cat>> fetchCats() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.thecatapi.com/v1/images/search?limit=10&has_breeds=1'),
        headers: {'x-api-key': 'live_l1rVNGYThuukX5MvQvrPpQCTe75EiqCcgHcUfQuXeSC9pfx3uly9NnI54Ch7JmZn'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Cat.fromJson(json)).toList();
      }
      throw Exception('API Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}