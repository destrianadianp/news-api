class ArtikelModel {
  final String title;
  final String? author;
  final String description;
  final String imageUrl;
  final String url;  // Add URL field
  final DateTime publishedAt;
  final String content;

  ArtikelModel({
    required this.title,
    this.author,
    required this.description,
    required this.url,  // Add URL field
    required this.publishedAt,
    required this.content,
    required this.imageUrl
  });

  factory ArtikelModel.fromJson(Map<String, dynamic> json) {
    return ArtikelModel(
      title: json['title'] ?? 'No title',
      author: json['author'] ?? 'No author',
      description: json['description'] ?? 'No description',
      imageUrl: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      url: json['url'] ?? '',  // Extract URL from JSON
      publishedAt: DateTime.parse(json['publishedAt']),
      content: json['content'] ?? 'Full content not available.',
    );
  }
}