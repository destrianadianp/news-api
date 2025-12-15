import 'package:get_it/get_it.dart';
import 'package:recreate_project/core/services/api_service.dart';
import 'package:recreate_project/core/services/get_bitcoin_news_usecase.dart';
import 'package:recreate_project/core/services/news_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Register ApiService
  getIt.registerSingleton(ApiService());

  // Register NewsRepository
  getIt.registerSingleton<NewsRepository>(NewsRepositoryImpl(getIt()));

  // Register UseCase
  getIt.registerSingleton(GetBitcoinNewsUsecase(getIt()));
}