import 'package:flutter/material.dart';
import '../../../../utility/widget/explore_view/genre_view.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../model/repository/upload_repo/fetch_data.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  final FetchData fetchData = FetchData();
  late Future<Map<String, List<Map<String, dynamic>>>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData.fetchAndGroupData();
  }

  Future<void> _refreshData() async {
    setState(() {
      dataFuture = fetchData.fetchAndGroupData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constant.primaryColor,
      appBar: AppBar(
        title: const Text('Explore Book'),
        centerTitle: true,
        backgroundColor: constant.primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            width: double.infinity,
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
            ),
          ),
        ),
      ),
    );
  }
}
