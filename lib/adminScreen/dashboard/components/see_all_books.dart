import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../../../../utility/route_transitiion/route_transition.dart';
import '../../../userScreen/book_page/details_page/detail_page.dart';
import '../../../userScreen/book_view_screen/pdf_view_screen.dart';
import '../../../userScreen/model/repository/upload_repo/fetch_data.dart';
import '../../main/components/side_menu.dart';

class SeeAllBooks extends StatefulWidget {
  const SeeAllBooks({super.key});

  @override
  State<SeeAllBooks> createState() => _SeeAllBooksState();
}

class _SeeAllBooksState extends State<SeeAllBooks> {
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

  Future<void> deleteBook(String bookId) async {
    try {
      final bookRef = FirebaseFirestore.instance.collection('books').doc(bookId);
      await bookRef.delete();
    } catch (e) {
      print('Error deleting book: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constant.primaryColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: constant.primaryColor,
      ),
      drawer: SideMenu(),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(constant.mainPageBg),
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: constraints.maxWidth + 500,
                    // Add extra width for horizontal scroll
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _futureBuilderBookView(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _futureBuilderBookView() {
    return FutureBuilder<List<List<Map<String, dynamic>>>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.black)),
          );
        } else if (snapshot.hasData) {
          final bookData = snapshot.data![0];
          return DataTable(
            dataRowMaxHeight: 60,
            columnSpacing: 8.0,
            headingRowColor: WidgetStateColor.resolveWith(
                    (states) => constant.kBackGroundColor),
            columns: const [
              DataColumn(
                  label: Text('Image',
                      style: TextStyle(color: Colors.black))),
              DataColumn(
                  label: Text('Title',
                      style: TextStyle(color: Colors.black))),
              DataColumn(
                  label: Text('Author',
                      style: TextStyle(color: Colors.black))),
              DataColumn(
                  label: Text('Category',
                      style: TextStyle(color: Colors.black))),
              DataColumn(
                  label: Text('Actions',
                      style: TextStyle(color: Colors.black))),
            ],
            rows: List<DataRow>.generate(bookData.length, (index) {
              final book = bookData[index];
              final color = index % 2 == 0 ? Colors.grey[200] : Colors.white;

              // Ensure book['id'] is not null before using it
              final String bookId = book['id'] ?? '';

              return DataRow(
                color: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.blue.withOpacity(0.08);
                      }
                      return color; // Use the alternating color here.
                    }),
                cells: [
                  DataCell(
                    Image.network(
                      book['photoUrl'] ?? '',
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error,
                            color: Colors.black);
                      },
                    ),
                  ),
                  DataCell(Text(book['bookName'] ?? '',
                      style: const TextStyle(color: Colors.black))),
                  DataCell(Text(book['authorName'] ?? '',
                      style: const TextStyle(color: Colors.black))),
                  DataCell(Text(book['category'] ?? '',
                      style: const TextStyle(color: Colors.black))),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).push(
                              customPageRouteFromTop(
                                PdfViewScreen(
                                    pdfUrl: book['pdfUrl'] ?? '',
                                    title: book['bookName']),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.info, color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).push(
                              customPageRouteFromTop(
                                DetailPageView(bookDetails: book),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          onPressed: () async {
                            // Ensure 'bookId' is not null before deleting
                            if (bookId.isNotEmpty) {
                              await deleteBook(bookId);

                              // Refresh the data after deleting
                              _refreshData();
                            } else {
                              print('Error: Book ID is null or empty');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        } else {
          return const Center(
            child: Text('No data available',
                style: TextStyle(color: Colors.black)),
          );
        }
      },
    );
  }
}
