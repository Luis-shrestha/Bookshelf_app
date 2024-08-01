import 'package:flutter/material.dart';

import '../../../utility/widget/explore_view/genre_view.dart';
import '../../model/repository/upload_repo/fetch_data.dart';

class ExploreBooks extends StatefulWidget {
  const ExploreBooks({super.key});

  @override
  State<ExploreBooks> createState() => _ExploreBooksState();
}

class _ExploreBooksState extends State<ExploreBooks> {
  final FetchData fetchData = FetchData();
  late Future<Map<String, List<Map<String, dynamic>>>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData.fetchAndGroupData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
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
          return Column(
            children: groupedData.entries.map((entry) {
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
    );
  }
}
