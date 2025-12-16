import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recreate_project/modules/list_artikel/view_model/list_artikel_view_model.dart';
import 'package:recreate_project/modules/search_artikel/view_model/search_artikel_view_model.dart';
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
          SearchBarComponent(
            onSearch: (String query) {
              if (query.isNotEmpty) {
                // Trigger search in SearchArtikelViewModel
                Provider.of<SearchArtikelViewModel>(context, listen: false).fetchSearchnews(query);
              } else {
                // If query is empty, fetch the default bitcoin news again
                Provider.of<ListArtikelViewModel>(context, listen: false).fetchBitcoinnews();
              }
            },
          ),

          Expanded(
            child: Selector<SearchArtikelViewModel, (List<bool>, String?)>(
              selector: (context, searchVm) => (searchVm.isLoading ? [true] : [false], searchVm.errorMessage),
              builder: (context, searchState, child) {
                final searchIsLoading = searchState.$1.first;
                final searchErrorMessage = searchState.$2;

                final searchVm = Provider.of<SearchArtikelViewModel>(context);
                final hasSearchResults = searchVm.artikel.isNotEmpty;

                if (searchIsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // If there's a search error, show error message
                if (searchErrorMessage != null) {
                  return Center(
                    child: Text(
                      'Search error: $searchErrorMessage',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  );
                }

                // If there are search results, display them
                if (hasSearchResults) {
                  return ListView.builder(
                    itemCount: searchVm.artikel.length,
                    itemBuilder: (context, index) {
                      final artikel = searchVm.artikel[index];
                      return NewsCard(artikel: artikel);
                    },
                  );
                }

                // fallback to the regular list view
                return Consumer<ListArtikelViewModel>(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}