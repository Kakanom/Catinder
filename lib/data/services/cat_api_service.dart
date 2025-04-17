import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cat.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CatApiService {
  Future<List<CatModel>> fetchCats() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.thecatapi.com/v1/images/search?limit=10&has_breeds=1'),
        headers: {'x-api-key': dotenv.env['CAT_API_KEY'] ?? ''},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CatModel.fromJson(json)).toList();
      }
      throw Exception('API Error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}
