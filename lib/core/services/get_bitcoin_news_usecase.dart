import 'package:recreate_project/core/models/artikel_model.dart';
import 'package:recreate_project/core/services/news_repository.dart';

class GetBitcoinNewsUsecase {
  final NewsRepository repository;

  GetBitcoinNewsUsecase(this.repository);

  Future<List<ArtikelModel>> call() async {
    return await repository.fetchBitcoinnews();
  }
}