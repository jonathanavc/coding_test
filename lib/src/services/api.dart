import 'dart:convert';
import 'package:coding_test/src/models/article.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  String apiUrl = '';
  String error = '';

  // constructor, cargar la url de la api
  ApiService() {
    try {
      if (dotenv.env['API_URL'] == null) {
        error = 'No API URL in .env file';
      }
      apiUrl = dotenv.env['API_URL']!;
    } catch (e) {
      error = 'Error loading .env file';
    }
  }

  // verificar si existe la url de la api
  bool verifyApiUrl() {
    if (apiUrl.isEmpty) {
      return false;
    }
    return true;
  }

  // obtener los datos de la api
  Future<List<Article>> fetchArticles() async {
    if (!verifyApiUrl()) {
      throw Exception(error);
    }
    final response = await http.get(Uri.parse('$apiUrl/api/v1/search_by_date?query=mobile'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      return jsonData['hits'].map<Article>((json) => Article.fromJson(json)).toList();

    } else {
      throw Exception('Failed to load data');
    }
  }
}