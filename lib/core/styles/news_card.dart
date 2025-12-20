import 'package:flutter/material.dart';
import 'package:recreate_project/core/models/artikel_model.dart';
import 'package:recreate_project/core/utils/date_formatter.dart';
import '../../modules/detail_artikel/views/detail_artikel_view.dart';
import 'app_colors.dart';

class NewsCard extends StatelessWidget {
  final ArtikelModel artikel;

  const NewsCard({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // Navigasi ke Detail View dengan mengirim ArticleModel
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailArtikelView (artikel: artikel),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  artikel.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artikel.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Deskripsi
                    Text(
                      artikel.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.secondary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tanggal
                    Text(
                      formatPublishedDate(artikel.publishedAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}