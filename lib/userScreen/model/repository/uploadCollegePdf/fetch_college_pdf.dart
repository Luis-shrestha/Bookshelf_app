import 'package:cloud_firestore/cloud_firestore.dart';

class FetchCollegePdf {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllPdf() async {
    final results = await _firebaseFirestore.collection('CollegePdf').get();
    return results.docs.map((e) {
      final data = e.data();
      data['id'] = e.id;  // Add the document ID to the data
      return data;
    }).toList();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchAndGroupData() async {
    final List<Map<String, dynamic>> collegePdf = await getAllPdf();
    final Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var collegePdf in collegePdf) {
      final subjectName = collegePdf['subjectName'] ?? 'Uncategorized';
      if (groupedData.containsKey(subjectName)) {
        groupedData[subjectName]!.add(collegePdf);
      } else {
        groupedData[subjectName] = [collegePdf];
      }
    }

    return groupedData;
  }
}
