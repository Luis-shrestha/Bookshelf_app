import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../../utility/constant/constant.dart' as constant;
import '../../../userScreen/book_view_screen/pdf_view_screen.dart';
import '../../../userScreen/model/repository/upload_repo/fetch_data.dart';
import '../../route_transitiion/route_transition.dart';
import '../reusable_widget/two_side_rounded_button.dart';

class BestOfTheDayCard extends StatefulWidget {
  final Size size;

  const BestOfTheDayCard({super.key, required this.size});

  @override
  State<BestOfTheDayCard> createState() => _BestOfTheDayCardState();
}

class _BestOfTheDayCardState extends State<BestOfTheDayCard> {
  final FetchData fetchData = FetchData();
  late Future<List<List<Map<String, dynamic>>>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = Future.wait([fetchData.getAllBook()]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<Map<String, dynamic>>>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final bookData = snapshot.data![0];
          Random random = new Random();
          int randomNumber = random.nextInt(bookData.length);
          return SizedBox(
            height: 285,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: 400,
                  height: 245,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          padding: EdgeInsets.only(left: 24, top: 24, right: widget.size.width * .35),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAEAEA).withOpacity(.45),
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10),
                              Text(
                                "Today's best Books",
                                style: TextStyle(fontSize: 9, color: constant.kLightBlackColor),
                              ),
                              Text(
                                bookData[randomNumber]['bookName'],
                              ),
                              Text(
                                bookData[randomNumber]['authorName'],
                                style: TextStyle(color: constant.kLightBlackColor),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: Text(
                                  bookData[randomNumber]['bookDescription'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 10, color: constant.kLightBlackColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 45,
                        child: Image.network(
                          bookData[randomNumber]['photoUrl'],
                          width: widget.size.width * .37,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: SizedBox(
                          height: 40,
                          width: widget.size.width * .3,
                          child: TwoSideRoundedButton(
                            text: "Read",
                            radius: 24,
                            onTap: () {  Navigator.of(context).push(
                              customPageRouteFromTop(
                                PdfViewScreen(pdfUrl: bookData[randomNumber]['pdfUrl'] ?? '', title: bookData[randomNumber]['bookName']),
                              ),
                            ); },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
