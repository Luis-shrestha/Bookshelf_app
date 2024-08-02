import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../supports/FavoriteManage/favorite_manager.dart';
import '../../utility/customBackground/abstract_background.dart';
import '../../utility/customBackground/bottom_circular_clipper.dart';
import '../../utility/route_transitiion/route_transition.dart';
import '../../utility/widget/reusable_widget/reading_card_list.dart';
import '../book_page/details_page/detail_page.dart';
import '../book_view_screen/pdf_view_screen.dart';
import '../../utility/constant/constant.dart' as constant;
import '../model/repository/upload_repo/fetch_data.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FetchData fetchData = FetchData();
  late Future<List<Map<String, dynamic>>> favoriteBooksFuture;

  @override
  void initState() {
    super.initState();
    _loadFavoriteBooks();
  }

  void _loadFavoriteBooks() {
    final favoriteManager = Provider.of<FavoriteManager>(context, listen: false);
    favoriteBooksFuture = fetchData.getAllBook().then((books) {
      // Filter the books based on favorite IDs
      return books.where((book) => favoriteManager.favorites.contains(book['id'])).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteManager = Provider.of<FavoriteManager>(context);

    return Scaffold(
      backgroundColor: constant.primaryColor,
      body: SafeArea(
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
            Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Favorite Screen",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: favoriteBooksFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No favorites yet.'));
                      }

                      final bookData = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: bookData.length,
                        itemBuilder: (context, index) {
                          final book = bookData[index];
                          final id = book['id'];
                          return ReadingCardList(
                            id: id,
                            image: book['photoUrl'],
                            title: book['bookName'],
                            auth: book['authorName'],
                            pressRead: () {
                              Navigator.of(context).push(
                                customPageRouteFromTop(
                                  PdfViewScreen(
                                    pdfUrl: book['pdfUrl'] ?? '',
                                    title: book['bookName'],
                                  ),
                                ),
                              );
                            },
                            detail: () {
                              Navigator.of(context).push(
                                customPageRouteFromTop(
                                  DetailPageView(
                                    bookDetails: book,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
