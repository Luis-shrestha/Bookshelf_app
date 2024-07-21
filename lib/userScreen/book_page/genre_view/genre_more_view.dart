import 'package:flutter/material.dart';
import 'package:shelf/utility/widget/reusable_widget/reading_card_list_second.dart';
import '../../../../../utility/constant/constant.dart' as constant;
import '../../../../../utility/route_transitiion/route_transition.dart';
import '../../book_view_screen/pdf_view_screen.dart';
import '../details_page/detail_page.dart';

class GenreMoreView extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> books;

  const GenreMoreView({
    required this.category,
    required this.books,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constant.primaryColor,
      appBar: AppBar(
        title: Text(category),
        backgroundColor: constant.primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(constant.bitmap),
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ReadingCardListSecond(
                image: book['photoUrl'] ?? '',
                title: book['bookName'] ?? 'Unknown Title',
                auth: book['authorName'] ?? 'Unknown Author',
                pressRead: () {
                  Navigator.of(context).push(
                    customPageRouteFromTop(
                      PdfViewScreen(pdfUrl: book['pdfUrl'] ?? '',  title: book['bookName']),
                    ),
                  );
                },
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
      ),
    );
  }
}
