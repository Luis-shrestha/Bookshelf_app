import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
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

  late Future<List<UserData>> _usersData;

  Future<List<UserData>> fetchAllUsersData() async {
    final usersData = await _firestore.collection('users').get();
    AppLog.i("Users Data", "${usersData.docs.length} users fetched");
    return usersData.docs.map((doc) => UserData.fromFirestore(doc)).toList();
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
        child: FutureBuilder<List<UserData>>(
          future: _usersData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No users found'));
            }

            final List<UserData> usersData = snapshot.data!;
            final UserDataSource _userDataSource = UserDataSource(
              users: usersData,
              onDeleteUser: deleteUser,
              onRefreshData: _refreshData,
            );

            return SfDataGrid(
              source: _userDataSource,
              columnWidthMode: ColumnWidthMode.fill,
              allowColumnsDragging: true,
              columns: <GridColumn>[
                GridColumn(
                  columnName: 'userPhoto',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Photo', style: TextStyle(color: Colors.black)),
                  ),
                ),
                GridColumn(
                  columnName: 'name',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Name', style: TextStyle(color: Colors.black)),
                  ),
                ),
                GridColumn(
                  columnName: 'email',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Email', style: TextStyle(color: Colors.black)),
                  ),
                ),
                GridColumn(
                  columnName: 'contact',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Contact', style: TextStyle(color: Colors.black)),
                  ),
                ),
                GridColumn(
                  columnName: 'bio',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Bio', style: TextStyle(color: Colors.black)),
                  ),
                ),
                GridColumn(
                  columnName: 'actions',
                  label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Actions', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class UserDataSource extends DataGridSource {
  final Future<void> Function(String userID) onDeleteUser;
  final Future<void> Function() onRefreshData;

  UserDataSource({
    required List<UserData> users,
    required this.onDeleteUser,
    required this.onRefreshData,
  }) {
    _userDataGridRows = users
        .map<DataGridRow>((data) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'userPhoto', value: data.userPhoto),
      DataGridCell<String>(columnName: 'name', value: data.name),
      DataGridCell<String>(columnName: 'email', value: data.email),
      DataGridCell<String>(columnName: 'contact', value: data.contact),
      DataGridCell<String>(columnName: 'bio', value: data.bio),
      DataGridCell<Widget>(
        columnName: 'actions',
        value: IconButton(
          icon: const Icon(Icons.delete, color: Colors.black),
          onPressed: () async {
            await onDeleteUser(data.id); // Call deleteUser function
            await onRefreshData(); // Refresh the data after deletion
          },
        ),
      ),
    ]))
        .toList();
  }

  List<DataGridRow> _userDataGridRows = [];

  @override
  List<DataGridRow> get rows => _userDataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Image.network(
          row.getCells()[0].value ?? '',
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, color: Colors.black);
          },
        ),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[1].value ?? '', style: const TextStyle(color: Colors.black)),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[2].value ?? '', style: const TextStyle(color: Colors.black)),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[3].value ?? '', style: const TextStyle(color: Colors.black)),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[4].value ?? '', style: const TextStyle(color: Colors.black)),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: row.getCells()[5].value,
      ),
    ]);
  }
}

class UserData {
  final String id;
  final String userPhoto;
  final String name;
  final String email;
  final String contact;
  final String bio;

  UserData({
    required this.id,
    required this.userPhoto,
    required this.name,
    required this.email,
    required this.contact,
    required this.bio,
  });

  factory UserData.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserData(
      id: doc.id,
      userPhoto: data['userPhoto'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      contact: data['contact'] ?? '',
      bio: data['bio'] ?? '',
    );
  }
}
