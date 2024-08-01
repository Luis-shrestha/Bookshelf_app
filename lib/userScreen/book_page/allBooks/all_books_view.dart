import 'package:flutter/material.dart';
import '../../../../../utility/constant/constant.dart' as constant;
import '../../../../../utility/route_transitiion/route_transition.dart';
import '../../../../../utility/widget/reusable_widget/reading_card_list_second.dart';
import '../../book_view_screen/pdf_view_screen.dart';
import '../../model/repository/upload_repo/fetch_data.dart';
import '../details_page/detail_page.dart';

class AllBooksView extends StatefulWidget {
  const AllBooksView({super.key});

  @override
  State<AllBooksView> createState() => _AllBooksViewState();
}

class _AllBooksViewState extends State<AllBooksView> {
  final FetchData fetchData = FetchData();
  late Future<List<List<Map<String, dynamic>>>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = Future.wait([fetchData.getAllBook()]);
  }

  Future<void> _refreshData() async {
    setState(() {
      dataFuture = Future.wait([fetchData.getAllBook()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constant.primaryColor,
      appBar: AppBar(
        title: const Text('Suggested for you'),
        centerTitle: true,
        backgroundColor: constant.primaryColor,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(constant.bitmap),
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FutureBuilder<List<List<Map<String, dynamic>>>>(
              future: dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final bookData = snapshot.data![0];
                  return Container(
                    // color: Colors.blue,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return ReadingCardListSecond(
                          image: bookData[index]['photoUrl'],
                          title: bookData[index]['bookName'],
                          auth: bookData[index]['authorName'],
                          pressRead: () {
                            Navigator.of(context).push(
                              customPageRouteFromTop(
                                PdfViewScreen(pdfUrl: bookData[index]['pdfUrl'] ?? '',  title: bookData[index]['bookName']),
                              ),
                            );
                          },
                          detail: () {
                            Navigator.of(context).push(
                              customPageRouteFromTop(
                                DetailPageView(bookDetails: bookData[index]),
                              ),
                            );
                          },

                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
