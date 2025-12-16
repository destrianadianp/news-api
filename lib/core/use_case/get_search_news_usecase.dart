import 'package:recreate_project/core/models/artikel_model.dart';
import 'package:recreate_project/core/repository/news_repository.dart';

class GetSearchNewsUsecase {
  final NewsRepository repository;

  GetSearchNewsUsecase (this.repository);

  Future<List<ArtikelModel>> call(String query) async{
    if (query.trim().isEmpty) {
      return Future.value([]);
    }
    return repository.fetchSearchnews(query);
  }
}