import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../supports/applog/applog.dart';
import '../../../utility/constant/constant.dart' as constant;
import '../../../utility/widget/explore_view/genre_view.dart';
import '../../../utility/widget/form_widget/custom_search_bar.dart';
import '../../model/repository/upload_repo/fetch_data.dart';

class ExploreBooks extends StatefulWidget {
  const ExploreBooks({super.key});

  @override
  State<ExploreBooks> createState() => _ExploreBooksState();
}

class _ExploreBooksState extends State<ExploreBooks> {
  final FetchData fetchData = FetchData();
  late Future<Map<String, List<Map<String, dynamic>>>> dataFuture;
  bool showExploreBooks = true;

  final ScrollController _scrollController = ScrollController();
  bool _isScrolledDown = false;

  TextEditingController searchController = TextEditingController();
  FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData.fetchAndGroupData();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!_isScrolledDown) {
        setState(() {
          _isScrolledDown = true;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (_isScrolledDown) {
        setState(() {
          _isScrolledDown = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        searchBar(),
        fetchBooks(),
      ],
    );
  }

  Widget searchBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      backgroundColor: constant.primaryColor,
      flexibleSpace: _isScrolledDown
          ? SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CustomSearchBar(
                  controller: searchController,
                  labelText: 'Search Books',
                  suffixIcon: Icons.search,
                  focusNode: _searchFocus,
                  onChanged: (val) {
                    setState(() {
                      // Trigger rebuild to reflect updated search results
                    });
                  },
                ),
              ),
            ),
    );
  }

  /*Widget fetchBooks() {
    return SliverToBoxAdapter(
      child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final groupedData = snapshot.data!;
            final searchQuery = searchController.text.toLowerCase();
            AppLog.d("searchQuery", "$searchQuery");

            final filteredData = groupedData.map((category, books) {
              final filteredBooks = books
                  .where((book) =>
                  book['title'].toString().toLowerCase().contains(searchQuery))
                  .toList();
              AppLog.d("Filtered Books", "$filteredBooks");

              return MapEntry(category, filteredBooks);
            }).entries.where((entry) => entry.value.isNotEmpty).toList();

            if (filteredData.isEmpty) {
              return const Center(child: Text('No books found matching the search criteria'));
            }

            return Column(
              children: filteredData.map((entry) {
                final category = entry.key;
                final books = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GenreView(books: books, category: category),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }*/
  Widget fetchBooks() {
    return SliverToBoxAdapter(
      child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final groupedData = snapshot.data!;
            final searchQuery = searchController.text.trim().toLowerCase();

            // Filter data based on the search query
            final filteredData = groupedData.map((category, books) {
              final filteredBooks = books.where((book) {
                final title = book['title']?.toString().toLowerCase() ?? '';
                return searchQuery.isEmpty || title.contains(searchQuery);
              }).toList();

              return MapEntry(category, filteredBooks);
            }).entries.where((entry) => entry.value.isNotEmpty).toList();

            if (filteredData.isEmpty) {
              return const Center(
                child: Text('No books found matching the search criteria'),
              );
            }

            return Column(
              children: filteredData.map((entry) {
                final category = entry.key;
                final books = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GenreView(books: books, category: category),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

}
