import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recreate_project/core/services/api_service.dart';
import 'package:recreate_project/core/services/get_bitcoin_news_usecase.dart';
import 'package:recreate_project/core/services/news_repository.dart';
import 'package:recreate_project/core/styles/theme.dart';
import 'package:recreate_project/di/dependency_injection.dart';
import 'package:recreate_project/modules/list_artikel/view_model/list_artikel_view_model.dart';
import 'package:recreate_project/modules/list_artikel/views/list_artikel_view.dart';

void main() {
  setupDependencies(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: getIt.get<ApiService>()),
        Provider.value(value: getIt.get<NewsRepository>()),
        Provider.value(value: getIt.get<GetBitcoinNewsUsecase>()),
        ChangeNotifierProvider(
          create: (context) => ListArtikelViewModel(
            getIt.get<GetBitcoinNewsUsecase>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'News App',
        theme: AppTheme.lightTheme,
        home: const ListArtikelView(), 
      ),
    );
  }
}
