import 'package:flutter/material.dart';
import 'package:recreate_project/core/models/artikel_model.dart';
import 'package:recreate_project/core/use_case/get_search_news_usecase.dart';

class SearchArtikelViewModel extends ChangeNotifier {
  final GetSearchNewsUsecase getSearchNewsUsecase;

  SearchArtikelViewModel(this.getSearchNewsUsecase);

  List<ArtikelModel> _artikel = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ArtikelModel> get artikel => _artikel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSearchnews(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await getSearchNewsUsecase(query);
      _artikel = result;
      _isLoading =false;
    } catch (e) {
       _errorMessage = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }
}