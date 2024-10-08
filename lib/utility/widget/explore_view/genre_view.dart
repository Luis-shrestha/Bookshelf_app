import 'package:flutter/material.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../../../userScreen/book_page/details_page/detail_page.dart';
import '../../../userScreen/book_page/genre_view/genre_more_view.dart';
import '../../../userScreen/book_view_screen/pdf_view_screen.dart';
import '../../route_transitiion/route_transition.dart';
import '../reusable_widget/reading_card_list.dart';

class GenreView extends StatelessWidget {
  final List<Map<String, dynamic>> books;
  final String category;

  const GenreView({
    required this.books,
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return books.isEmpty
        ? SizedBox.shrink()
        : Container(
      decoration: BoxDecoration(
        color: Colors.white38,
        boxShadow: [
          BoxShadow(
            spreadRadius: 5,
            blurRadius: 5,
            color: Colors.black12,
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: constant.kHeading2TextStyle.textTheme.bodyMedium,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      customPageRouteFromRight(
                        GenreMoreView(
                          category: category,
                          collegePdf: books,
                        ),
                      ),
                    );
                  },
                  child: const Text("view more>>"),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 285,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ReadingCardList(
                  id: book['id'],
                  image: book['photoUrl'] ?? '',
                  title: book['bookName'] ?? 'Unknown Title',
                  auth: book['authorName'] ?? 'Unknown Author',
                  pressRead: () {
                    Navigator.of(context).push(
                      customPageRouteFromTop(
                        PdfViewScreen(pdfUrl: book['pdfUrl'] ?? '', title: book['bookName']),
                      ),
                    );
                  },
                  heroTag: 'bookImageHero_${book['id']}',
                  detail: () {
                    Navigator.of(context).push(
                      customPageRouteFromTop(
                        DetailPageView(bookDetails: book),
                      ),
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
