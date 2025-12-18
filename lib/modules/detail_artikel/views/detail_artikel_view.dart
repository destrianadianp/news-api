import 'package:flutter/material.dart';
import 'package:recreate_project/core/models/artikel_model.dart';
import 'package:recreate_project/core/styles/custom_button.dart';
import 'package:recreate_project/modules/web_view/controller/web_view_controller.dart';
import '../../../core/utils/date_formatter.dart';

import '../../../core/styles/app_colors.dart';

class DetailArtikelView extends StatelessWidget {
  final ArtikelModel artikel;
  const DetailArtikelView({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          artikel.title.length > 30
            ? '${artikel.title.substring(0, 27)}...'
            : artikel.title,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Utama (dengan error builder menggunakan AppColors)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                artikel.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              artikel.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                if (artikel.author != null)
                  Expanded(
                    child: Text(
                      'By: ${artikel.author!}',
                      style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 13),
                    ),
                  ),
                Text(
                  formatPublishedDate(artikel.publishedAt),
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 13),
                ),
              ],
            ),

            const Divider(height: 32),

            // Deskripsi & Konten (Ringkasan)
            Text(
              artikel.description,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            Text(
              artikel.content,
              style: const TextStyle(fontSize: 16, height: 1.5, color: AppColors.textDark),
            ),

            const SizedBox(height: 30),

            Center(
              child: CustomButton(
                onPressed: () {
                  // Check if URL is valid before navigating
                  if (artikel.url.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsWebViewPage(url: artikel.url, title: artikel.title)
                      ),
                    );
                  } else {
                    // Show error if URL is not available
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URL tidak ditemukan untuk artikel ini')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}