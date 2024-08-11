import 'package:flutter/material.dart';
import 'package:shelf/userScreen/model/repository/uploadCollegePdf/fetch_college_pdf.dart';

import '../../../utility/widget/explore_view/college_pdf_view.dart';

class ExploreCollegeBooks extends StatefulWidget {
  const ExploreCollegeBooks({super.key});

  @override
  State<ExploreCollegeBooks> createState() => _ExploreCollegeBooksState();
}

class _ExploreCollegeBooksState extends State<ExploreCollegeBooks> {
  final FetchCollegePdf fetchData = FetchCollegePdf();
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
          return SingleChildScrollView(  // This makes the entire view scrollable
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groupedData.entries.map((entry) {
                final category = entry.key;
                final collegePdf = entry.value;

                return CollegePdfView(books: collegePdf, category: category);
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
