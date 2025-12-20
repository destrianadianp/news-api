import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recreate_project/core/models/artikel_model.dart';
import 'package:recreate_project/core/models/response_model.dart';
import 'package:recreate_project/core/services/api_headers.dart';

class ApiService {
  static const String _apiKey = 'db27e9185a7b45259008fd1fa4164d93'; 
  static const String _baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<ArtikelModel>> getBitcoinNews() async {
    final url = Uri.parse('$_baseUrl?q=bitcoin&sortBy=publishedAt&apiKey=$_apiKey');

    try {
      final response = await http.get(
        url,
        headers: ApiHeaders.headers
      );
      if (response.statusCode == 200) {
        final jsonBody =  json.decode(response.body);
        final newsResponse = ResponseModel.fromJson(jsonBody);

        return newsResponse.articles;
      } else {
        throw Exception('Failed to load news. Status Code : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  Future<List<ArtikelModel>> getSearchNews(String query) async {
    final url = Uri.parse('$_baseUrl?q=$query&from=2025-12-15&sortBy=popularity&apiKey=$_apiKey');

    try {
      final response = await http.get(
        url,
        headers: ApiHeaders.headers
      );
      if (response.statusCode == 200) {
        final jsonBody =  json.decode(response.body);
        final searchResponse = ResponseModel.fromJson(jsonBody);

        return searchResponse.articles;
      } else {
        throw Exception('Failed to load news. Status Code : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

}