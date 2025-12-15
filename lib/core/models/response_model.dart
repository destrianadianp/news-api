import 'package:recreate_project/core/models/artikel_model.dart';

class ResponseModel {
  final String status;
  final int totalResults;
  final List<ArtikelModel> articles;

  ResponseModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });
  factory ResponseModel.fromJson(Map<String, dynamic> json){
    var list = json['articles'] as List;
    List<ArtikelModel> articleList = list.map((i)=> ArtikelModel.fromJson(i)).toList();
    
    return ResponseModel(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: articleList
    );
  }
}