import 'package:recreate_project/core/models/artikel_model.dart';
import 'package:recreate_project/core/services/api_service.dart';

abstract class NewsRepository {
  Future<List<ArtikelModel>> fetchBitcoinnews();
  Future<List<ArtikelModel>> fetchSearchnews(String query);
}

class NewsRepositoryImpl implements NewsRepository {
  final ApiService apiService;

  NewsRepositoryImpl(this.apiService);

  @override
  Future<List<ArtikelModel>> fetchBitcoinnews() async {
    return await apiService.getBitcoinNews();
  }


  Future<List<ArtikelModel>> fetchSearchnews(String query) async {
    try {
      final artikel = await apiService.getSearchNews(query);
      return artikel;
    } catch (e) {
      throw Exception('Failed to load news: $e');      
    }
  }
}