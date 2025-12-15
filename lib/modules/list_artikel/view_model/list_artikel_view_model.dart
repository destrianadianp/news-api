import 'package:flutter/material.dart';
import 'package:recreate_project/core/models/artikel_model.dart';
import 'package:recreate_project/core/services/get_bitcoin_news_usecase.dart';

class ListArtikelViewModel extends ChangeNotifier {
  final GetBitcoinNewsUsecase getNewsUseCase;

  ListArtikelViewModel(this.getNewsUseCase);

  List<ArtikelModel> _artikel = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ArtikelModel> get artikel => _artikel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBitcoinnews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await getNewsUseCase.call();
      _artikel = result;
      _isLoading =false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }

    notifyListeners();
  }
}