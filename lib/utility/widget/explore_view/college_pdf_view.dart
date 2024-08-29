import 'package:flutter/material.dart';
import 'package:shelf/userScreen/book_page/details_page/detail_college_pdf.dart';
import 'package:shelf/userScreen/book_page/genre_view/college_pdf_more_view.dart';
import 'package:shelf/utility/route_transitiion/route_transition.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../../../userScreen/book_page/genre_view/genre_more_view.dart';
import '../../../userScreen/book_view_screen/pdf_view_screen.dart';
import '../reusable_widget/reading_card_list.dart';

class CollegePdfView extends StatelessWidget {
  final List<Map<String, dynamic>> books;
  final String category;

  const CollegePdfView({
    required this.books,
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        /* border: Border(
          bottom: BorderSide(
              width: 1, color: Colors.black38, style: BorderStyle.solid),
        ),*/
          color: Colors.white38,
          boxShadow: [
            BoxShadow(
                spreadRadius: 5,
                blurRadius: 5,
                color: Colors.black12
            ),
          ],
          borderRadius: BorderRadius.circular(20.0)
      ),
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.only(top: 8.0, left: 16.0,right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category,
                    style: constant.kHeading2TextStyle.textTheme.bodyMedium),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      customPageRouteFromRight(
                        CollegePdfMoreView(
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
              // itemCount: 6,
              itemCount: books.length,
              itemBuilder: (context, index) {
                final collegePdf = books[index];
                return ReadingCardList(
                  id: collegePdf['id'],
                  image: collegePdf['photoUrl'] ?? '',
                  title: collegePdf['chapterName'] ?? 'Unknown Title',
                  auth: collegePdf['authorName'] ?? 'Unknown Author',
                  pressRead: () {
                    Navigator.of(context).push(
                      customPageRouteFromTop(
                        PdfViewScreen(pdfUrl: collegePdf['pdfUrl'] ?? '', title: collegePdf['chapterName']),
                      ),
                    );
                  },
                  heroTag: 'bookImageHero_${collegePdf['id']}',
                  detail: () {
                    Navigator.of(context).push(
                      customPageRouteFromTop(
                        DetailCollegePdfPageView(bookDetails: collegePdf),
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
