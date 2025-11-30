import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';
import '../utils/constants.dart';

class ApiService {
  Future<List<Article>> fetchArticles(String category) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getEndpoint(category)),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Article> articles = [];
        
        for (var item in data['results']) {
          articles.add(Article.fromJson(item));
        }
        
        return articles;
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Article> fetchArticleDetail(String category, String id) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getDetailEndpoint(category, id)),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Article.fromJson(data);
      } else {
        throw Exception('Failed to load article detail');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}