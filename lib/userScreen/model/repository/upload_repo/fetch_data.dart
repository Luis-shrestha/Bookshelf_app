import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../supports/applog/applog.dart';

class FetchData {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllBook() async {
    final results = await _firebaseFirestore.collection('books').get();
    return results.docs.map((e) {
      final data = e.data();
      data['id'] = e.id;  // Add the document ID to the data
      return data;
    }).toList();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchAndGroupData() async {
    final List<Map<String, dynamic>> books = await getAllBook();
    final Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var book in books) {
      final category = book['category'] ?? 'Uncategorized';
      if (groupedData.containsKey(category)) {
        groupedData[category]!.add(book);
      } else {
        groupedData[category] = [book];
      }
    }

    return groupedData;
  }

  /*Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    final allBooks = await getAllBook();
    final filteredBooks = allBooks.where((book) {
      final title = book['title']?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();

    AppLog.i('Filtered Books:','$filteredBooks'); // Debugging statement
    return filteredBooks;
  }*/
}
