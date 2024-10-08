import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import '../../../../../utility/constant/constant.dart' as constant;
import '../../../../../utility/route_transitiion/route_transition.dart';
import '../../../helper/notificationHelper/notification_service.dart';
import '../../../supports/applog/applog.dart';
import '../../book_view_screen/pdf_view_screen.dart';
import '../../model/repository/upload_repo/fetch_data.dart';

class DetailPageView extends StatefulWidget {
  final Map<String, dynamic> bookDetails;

  const DetailPageView({super.key, required this.bookDetails});

  @override
  State<DetailPageView> createState() => _DetailPageViewState();
}

class _DetailPageViewState extends State<DetailPageView> {
  final FetchData fetchData = FetchData();
  final NotificationService notificationService = NotificationService(); // Instantiate the NotificationService

  late Future<List<List<Map<String, dynamic>>>> dataFuture;
  double? _progress;
  bool _isDownloading = false;
  bool _isCanceled = false;
  StreamSubscription? _downloadSubscription;

  @override
  void initState() {
    super.initState();
    dataFuture = Future.wait([fetchData.getAllBook()]);
    notificationService.initialize(); // Initialize the notification service
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.bookDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text(book['bookName']),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: <Widget>[
            backgroundStyle(),
            Positioned.fill(
              top: 200,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 3,
                                blurRadius: 2,
                                color: Colors.black12,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 85.0),
                          child: Column(
                            children: [
                              Text(
                                book['bookName'],
                                style: constant
                                    .kRegularTextStyle.textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              bookRating(),
                              const SizedBox(height: 28),
                              bookDetails(),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  startReadingButton(),
                                  downloadButton(),
                                ],
                              ),
                              description(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: 'bookImageHero_${widget.bookDetails['id']}', // Use the same tag as in the Dashboard
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 2,
                        blurRadius: 17,
                        offset: Offset(5, 8),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.bookDetails['photoUrl'],
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                      height: 250,
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget backgroundStyle() {
    final book = widget.bookDetails;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(book['photoUrl']),
          // Image URL from book details
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: Colors.black.withOpacity(0), // This can be adjusted if needed
        ),
      ),
    );
  }

  Widget bookRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.star_rounded),
        Icon(Icons.star_rounded),
        Icon(Icons.star_rounded),
        Icon(Icons.star_rounded),
        Icon(Icons.star_half_rounded),
        Text(
          "4.5",
          style: constant.kRegularTextStyle.textTheme.bodySmall,
        )
      ],
    );
  }

  Widget bookDetails() {
    final book = widget.bookDetails;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/genre.png'),
            Text("Category",
                style: constant.kRegular2TextStyle.textTheme.bodySmall),
            Text(book['category'])
          ],
        ),
        Container(
          color: Colors.black38,
          height: 100,
          width: 2,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/author.png'),
            Text("Author",
                style: constant.kRegular2TextStyle.textTheme.bodySmall),
            Text(book['authorName']),
          ],
        ),
      ],
    );
  }

  Widget startReadingButton() {
    final book = widget.bookDetails;
    return SizedBox(
      width: 180,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            customPageRouteFromTop(
              PdfViewScreen(
                  pdfUrl: book['pdfUrl'] ?? '', title: book['bookName']),
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          // To constrain the row width to fit the children
          children: <Widget>[
            Image.asset(
              'assets/icons/read.png',
              height: 24,
            ),
            SizedBox(width: 8), // Space between icon and text
            Text(
              "Start Reading",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget downloadButton() {
    final book = widget.bookDetails;
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          _isCanceled = false; // Reset the cancel flag
          showDownloadDialog(); // Show the dialog when the button is pressed

          try {
            _isDownloading = true; // Set the downloading flag

            await FileDownloader.downloadFile(
              url: book['pdfUrl'],
              onProgress: (name, progress) {
                AppLog.d("Download Url", "${book['pdfUrl']}");
                setState(() {
                  _progress = progress / 100;
                });

                if (_isCanceled) {
                  _downloadSubscription?.cancel(); // Cancel the download
                  setState(() {
                    _progress = null;
                    _isDownloading = false;
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
                onDownloadCompleted: (filePath) async {
                  if (!_isCanceled) {
                    setState(() {
                      _progress = null;
                      _isDownloading = false;
                    });
                    Navigator.of(context).pop(); // Close the dialog
                    AppLog.d("Download completed:", "${filePath}");

                    try {
                      // Show notification on download completion
                      await notificationService.showNotification(
                          "Download Complete",
                          "The book ${book['bookName']} has been downloaded successfully."
                      );
                    } catch (e) {
                      AppLog.d("Notification Error:", "$e");
                    }

                    // Show a toast message using a SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Download completed: ${book['bookName']}",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },


                onDownloadError: (error) {
                if (!_isCanceled) {
                  setState(() {
                    _progress = null;
                    _isDownloading = false;
                  });
                  Navigator.of(context).pop(); // Close the dialog
                  AppLog.d("Download Error:", " $error");
                }
              },
            );
          } catch (e) {
            if (!_isCanceled) {
              setState(() {
                _progress = null;
                _isDownloading = false;
              });
              Navigator.of(context).pop(); // Close the dialog
              AppLog.d("Download failed:", "$e");
            }
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/icons/download.png',
              height: 24,
            ),
            SizedBox(width: 8),
            Text("Download", style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget description() {
    final book = widget.bookDetails;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Description",
              style: constant.kRegular2TextStyle.textTheme.bodySmall),
          const SizedBox(
            height: 8,
          ),
          Text(
            book['bookDescription'],
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      dataFuture = Future.wait([fetchData.getAllBook()]);
    });
  }

  void showDownloadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Downloading...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _progress != null
                  ? CircularProgressIndicator(value: _progress)
                  : CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Please wait while the file is downloading.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _isCanceled = true; // Set the cancel flag
                setState(() {
                  _progress = null;
                  _isDownloading = false;
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
