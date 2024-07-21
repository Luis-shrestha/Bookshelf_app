import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../supports/applog/applog.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../../main/components/side_menu.dart';

class ManageUsersView extends StatefulWidget {
  const ManageUsersView({super.key});

  @override
  State<ManageUsersView> createState() => _ManageUsersViewState();
}

class _ManageUsersViewState extends State<ManageUsersView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<QuerySnapshot<Map<String, dynamic>>?> _usersData;

  Future<QuerySnapshot<Map<String, dynamic>>?> fetchAllUsersData() async {
    final usersData = await _firestore.collection('users').get();
    AppLog.i("Users Data", "${usersData.docs.length} users fetched");
    return usersData;
  }

  @override
  void initState() {
    super.initState();
    _usersData = fetchAllUsersData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _usersData = fetchAllUsersData();
    });
  }

  Future<void> deleteUser(String userID) async {
    try {
      // Delete user document from Firestore
      final userRef = _firestore.collection('users').doc(userID);
      await userRef.delete();

      // Delete user from Firebase Authentication
      User? user = await _auth.currentUser;
      await user?.delete();
    } catch (e) {
      print('Error deleting user: $e');
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: usersDataTable(),
          ),
        ),
      ),
    );
  }

  Widget usersDataTable() {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>?>(
      future: _usersData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        final List<QueryDocumentSnapshot<Map<String, dynamic>>> usersDocs = snapshot.data!.docs;

        return Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              child: DataTable(
                dataRowMaxHeight: 60,
                columnSpacing: 8.0,
                headingRowColor: MaterialStateColor.resolveWith(
                      (states) => constant.kBackGroundColor,
                ),
                columns: const [
                  DataColumn(label: Text('Photo', style: TextStyle(color: Colors.black))),
                  DataColumn(label: Text('Name', style: TextStyle(color: Colors.black))),
                  DataColumn(label: Text('Email', style: TextStyle(color: Colors.black))),
                  DataColumn(label: Text('Contact', style: TextStyle(color: Colors.black))),
                  DataColumn(label: Text('Bio', style: TextStyle(color: Colors.black))),
                  DataColumn(label: Text('Actions', style: TextStyle(color: Colors.black))),
                ],
                rows: usersDocs.map((userDoc) {
                  final Map<String, dynamic> userData = userDoc.data();
                  final String userId = userDoc.id;
                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.blue.withOpacity(0.08);
                        }
                        return Colors.grey[200]; // Alternating row color.
                      },
                    ),
                    cells: [
                      DataCell(
                        Image.network(
                          userData['userPhoto'] ?? '',
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error,
                                color: Colors.black);
                          },
                        ),
                      ),
                      DataCell(Text(userData['name'] ?? '', style: const TextStyle(color: Colors.black))),
                      DataCell(Text(userData['email'] ?? '', style: const TextStyle(color: Colors.black))),
                      DataCell(Text(userData['contact'] ?? '', style: const TextStyle(color: Colors.black))),
                      DataCell(Text(userData['bio'] ?? '', style: const TextStyle(color: Colors.black))),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.black),
                              onPressed: () async {
                                if (userId.isNotEmpty) {
                                  await deleteUser(userId);
                                  _refreshData();
                                } else {
                                  print('Error: User ID is null or empty');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
