import 'package:flutter/material.dart';
import 'package:shelf/userScreen/book_page/genre_view/exploreCollegeBooks.dart';
import 'package:shelf/userScreen/book_page/genre_view/explore_books.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../../utility/customBackground/abstract_background.dart';
import '../../utility/customBackground/bottom_circular_clipper.dart';
import '../model/repository/upload_repo/fetch_data.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final FetchData fetchData = FetchData();
  late Future<Map<String, List<Map<String, dynamic>>>> dataFuture;
  bool showExploreBooks = true;

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

  void _swapView() {
    setState(() {
      showExploreBooks = !showExploreBooks;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: constant.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Explore Book'),
        centerTitle: true,
        backgroundColor: constant.primaryColor,
        actions: [
          GestureDetector(
            onTap: _swapView,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.swap_horiz_rounded),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            SizedBox(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: ClipPath(
                clipper: BottomCircularClipper(),
                child: CustomPaint(
                  painter: AbstractBackgroundPainter(),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: showExploreBooks
                  ? ExploreBooks()
                  : ExploreCollegeBooks(),
            ),
          ],
        ),
      ),
    );
  }
}
