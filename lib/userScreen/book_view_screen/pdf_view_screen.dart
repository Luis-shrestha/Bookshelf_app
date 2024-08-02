import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utility/constant/constant.dart' as constant;
import '../../supports/applog/applog.dart';

class PdfViewScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfViewScreen({super.key, required this.pdfUrl, required this.title});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  String? localFilePath;
  bool isDark = false;
  int currentPage = 0;
  int totalPages = 0;
  PDFViewController? pdfViewController;
  List<int> bookmarks = [];
  String? userId;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserData().then((userData) {
      if (userData != null) {
        setState(() {
          userId = userData.id;
        });
        loadBookmarks();
      }
    });
    downloadAndSavePdf();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchCurrentUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      AppLog.i("User Data", "${userData.data()}");
      return userData;
    } else {
      AppLog.i("User:", "No user logged in");
      return null;
    }
  }

  Future<void> downloadAndSavePdf() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(bytes, flush: true);
      setState(() {
        localFilePath = file.path;
      });
    } catch (e) {
      print("Error downloading PDF: $e");
    }
  }

  String getBookmarkKey() {
    return 'bookmarks_${widget.pdfUrl}_${userId}';
  }

  Future<void> loadBookmarks() async {
    if (userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarks = prefs.getStringList(getBookmarkKey())?.map((e) => int.parse(e)).toList() ?? [];
      if (bookmarks.isNotEmpty) {
        currentPage = bookmarks.last;
      }
    });
  }

  Future<void> saveBookmarks() async {
    if (userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(getBookmarkKey(), bookmarks.map((e) => e.toString()).toList());
  }

  void toggleBookmark() {
    setState(() {
      if (bookmarks.contains(currentPage)) {
        bookmarks.remove(currentPage);
      } else {
        bookmarks.add(currentPage);
      }
      saveBookmarks();
      AppLog.d("Bookmarks", '$bookmarks');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constant.kBackGroundColor,
      appBar: AppBar(
        title: Text('${widget.title} (${currentPage + 1}/$totalPages)'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isDark = !isDark;
              });
              AppLog.d("isDark", '$isDark');
              pdfViewController?.setPage(currentPage); // Refresh the page to apply night mode
            },
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
          ),
          IconButton(
            onPressed: toggleBookmark,
            icon: Icon(
              bookmarks.contains(currentPage) ? Icons.bookmark : Icons.bookmark_border,
            ),
          ),
        ],
      ),
      body: localFilePath != null
          ? PDFView(
        key: Key(isDark.toString()), // Add a Key to force rebuild
        fitEachPage: true,
        nightMode: isDark,
        // defaultPage: bookmarks,
        filePath: localFilePath!,
        onViewCreated: (controller) {
          pdfViewController = controller;
          controller.getPageCount().then((count) {
            setState(() {
              totalPages = count ?? 0;
            });
          });
          if (bookmarks.isNotEmpty) {
            controller.setPage(bookmarks.last); // Set to last bookmarked page
          }
        },
        onPageChanged: (page, total) {
          setState(() {
            currentPage = page ?? 0;
            totalPages = total ?? 0;
          });
        },
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
