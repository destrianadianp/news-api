import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recreate_project/modules/list_artikel/view_model/list_artikel_view_model.dart';
import 'package:recreate_project/modules/search_artikel/components/searchbar.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/news_card.dart';

class ListArtikelView extends StatefulWidget {
  const ListArtikelView({super.key});

  @override
  State<ListArtikelView> createState() => _ListArtikelViewState();
}

class _ListArtikelViewState extends State<ListArtikelView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListArtikelViewModel>(context, listen: false).fetchBitcoinnews();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search bar at the top
          SearchBarComponent(
            onSearch: (String query) {
              if (query.isNotEmpty) {
                // Trigger search in the same ViewModel
                Provider.of<ListArtikelViewModel>(context, listen: false).fetchSearchnews(query);
              } else {
                // If query is empty, fetch the default bitcoin news again
                Provider.of<ListArtikelViewModel>(context, listen: false).fetchBitcoinnews();
              }
            },
          ),

          // Expanded list view to show articles
          Expanded(
            child: Consumer<ListArtikelViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.errorMessage != null) {
                  return Center(
                    child: Text(
                      'Failed to load news: ${viewModel.errorMessage!}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  );
                }

                if (viewModel.artikel.isEmpty) {
                  return const Center(
                    child: Text('No articles found.'),
                  );
                }

                return ListView.builder(
                  itemCount: viewModel.artikel.length,
                  itemBuilder: (context, index) {
                    final artikel = viewModel.artikel[index];
                    return NewsCard(artikel: artikel);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}