import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shelf/supports/applog/applog.dart';
import '../../../utility/customBackground/abstract_background.dart';
import '../../../utility/customBackground/bottom_circular_clipper.dart';
import '../../../utility/constant/constant.dart' as constant;
import '../../../utility/route_transitiion/route_transition.dart';
import '../../../utility/widget/profile_view_widget/CustomGestureDetector.dart';
import '../../../utility/widget/reusable_widget/reading_card_list.dart';
import '../authentication_screen/user_logout_screen.dart';
import '../book_page/allBooks/all_books_view.dart';
import '../book_page/details_page/detail_page.dart';
import '../book_page/editProfile/edit_profile_view.dart';
import '../book_view_screen/pdf_view_screen.dart';
import '../model/repository/upload_repo/fetch_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // to fetch data from the firebase storage
  final FetchData fetchData = FetchData();
  late Future<List<List<Map<String, dynamic>>>> dataFuture;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<DocumentSnapshot<Map<String, dynamic>>?> _userData;

  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchCurrentUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      AppLog.i("User Data", "${userData}");
      return userData;
    } else {
      AppLog.i("User:", "No user logged in");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _userData = fetchCurrentUserData();

    dataFuture = Future.wait([fetchData.getAllBook()]);
  }

  double padding = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constant.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Stack(
              children: [
                SizedBox(
                  height: 250,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: ClipPath(
                    clipper: BottomCircularClipper(),
                    child: CustomPaint(
                      painter: AbstractBackgroundPainter(),
                    ),
                  ),
                ),
                profileView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileView() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
              color: Theme
                  .of(context)
                  .colorScheme
                  .onPrimaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                profileData(),
                const SizedBox(height: 16),
                editProfileButton(),
                const SizedBox(height: 16),
                suggestedBookView(),
                CustomGestureDetector(
                  icon: Icons.exit_to_app,
                  title: "Logout",
                  subTitle: 'Logout from this app',
                  onTap: () {
                    showLogoutDialog(context);
                  },
                  iconColor: Theme
                      .of(context)
                      .iconTheme
                      .color,
                  titleColor: Colors.black,
                  subtitleColor: Theme
                      .of(context)
                      .textTheme
                      .bodySmall
                      ?.color,
                ),
              ],
            ),
          ),
        ),
        profileImage(),
      ],
    );
  }

  Widget profileData() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      future: _userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            !snapshot.data!.exists) {
          return const Center(child: Text('No user signed in'));
        }

        final userDoc = snapshot.data!;
        final Map<String, dynamic> userData = userDoc.data()!;
        final String name = userData['name'] ?? 'N/A';
        final String email = userData['email'] ?? 'N/A';
        final String bio = userData['bio'] ?? 'N/A';
        AppLog.i("Profile Screen User Data", "${name}${email}");
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Name: $name',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: $email',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                bio.isEmpty? "" : 'Bio: $bio',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget editProfileButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: constant.primaryColor,
          foregroundColor: Colors.black,
          elevation: 8,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)) // Change button shape
      ),
      onPressed: () {
        _userData.then((userDoc) {
          if (userDoc != null && userDoc.exists) {
            final userData = userDoc.data()!;
            Navigator.of(context).push(
              customPageRouteFromBottom(
                EditProfileView(
                  userData: userData,
                ),
              ),
            );
          }
        });
      },
      child: Text('Edit Profile'),
    );
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                UserLogoutScreen.logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget profileImage() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 55.0, left: 160),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
            future: _userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
                return const Center(child: Text('No user signed in'));
              }

              final userDoc = snapshot.data!;
              final Map<String, dynamic> userData = userDoc.data()!;
              final userPhotoUrl = userData['userPhoto'];

              return Hero(
                tag: 'Profile',
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: userPhotoUrl != null
                      ? NetworkImage(userPhotoUrl)
                      : AssetImage('assets/icons/user.png') as ImageProvider,
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  Widget suggestedBookView() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          spreadRadius: 0,
          blurRadius: 5,
          color: Theme
              .of(context)
              .shadowColor,
        )
      ]),
      child: Padding(
        padding: EdgeInsets.only(top: padding, left: padding, right: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Suggested for you",
                  style: constant.kRegular2TextStyle.textTheme.bodySmall,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      customPageRouteFromTop(
                        AllBooksView(),
                      ),
                    );
                  },
                  child: Text(
                    "view more",
                    style: constant.kRegular2TextStyle.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            _futureBuilderBookView(),
          ],
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
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final bookData = snapshot.data![0];
          Random random = new Random();
          int randomNumber = random.nextInt(bookData.length);
          return SizedBox(
            height: 285,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return ReadingCardList(
                  image: bookData[index]['photoUrl'],
                  title: bookData[index]['bookName'],
                  auth: bookData[index]['authorName'],
                  pressRead: () {
                    Navigator.of(context).push(
                      customPageRouteFromTop(
                        PdfViewScreen(
                            pdfUrl: bookData[index]['pdfUrl'] ?? '',
                            title: bookData[index]['authorName']),
                      ),
                    );
                  },
                  detail: () {
                    Navigator.of(context).push(
                      customPageRouteFromTop(
                        DetailPageView(bookDetails: bookData[index]),
                      ),
                    );
                  }, id: bookData[index]['id'],
                  heroTag: 'bookImageHero_${bookData[index]['id']}',
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
/*CustomGestureDetector(
                icon: Icons.exit_to_app,
                title: "Theme Setting",
                subTitle: 'Change theme mode dark/light',
                onTap: () {
                  Navigator.of(context).push(
                    customPageRouteFromLeft(
                      ThemeView(),
                    ),
                  );
                },
                iconColor: Theme.of(context).iconTheme.color,
                titleColor: Colors.black,
                subtitleColor: Theme.of(context).textTheme.bodySmall?.color,
              ),*/
