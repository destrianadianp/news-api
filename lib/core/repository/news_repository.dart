import 'package:recreate_project/core/models/artikel_model.dart';
import 'package:recreate_project/core/services/api_service.dart';

abstract class NewsRepository {
  Future<List<ArtikelModel>> fetchBitcoinnews();
}

class NewsRepositoryImpl implements NewsRepository {
  final ApiService apiService;

  NewsRepositoryImpl(this.apiService);

  @override
  Future<List<ArtikelModel>> fetchBitcoinnews() async {
    return await apiService.getBitcoinNews();
  }
}