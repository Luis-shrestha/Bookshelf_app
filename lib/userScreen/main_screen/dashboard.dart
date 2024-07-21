import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shelf/utility/route_transitiion/route_transition.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../../../../utility/widget/home_screen_widget/best_of_the_day_card.dart';
import '../../../../utility/widget/reusable_widget/reading_card_list.dart';
import '../book_page/details_page/detail_page.dart';
import '../book_view_screen/pdf_view_screen.dart';
import '../model/repository/upload_repo/fetch_data.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FetchData fetchData = FetchData();
  late Future<List<List<Map<String, dynamic>>>> dataFuture;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<DocumentSnapshot<Map<String, dynamic>>?> _userData;

  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchCurrentUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      return userData;
    } else {
      return null;
    }
  }
  @override
  void initState() {
    super.initState();
    _userData = fetchCurrentUserData();

    dataFuture = Future.wait([fetchData.getAllBook()]);
  }

  Future<void> _refreshData() async {
    setState(() {
      dataFuture = Future.wait([fetchData.getAllBook()]);
    });
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
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
        final String name = userData['name'] ?? 'N/A';
        return  Scaffold(
          backgroundColor: constant.primaryColor,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(

                backgroundImage: AssetImage(
                  'assets/icons/user.png',
                ), // Replace with your image URL
              ),
            ),
            backgroundColor: constant.primaryColor,
            title: Text( 'Welcome $name',),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(constant.mainPageBg),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: size.height * .05),
                        whatAreYouReadingTodayText(),
                        const SizedBox(height: 30),
                        _futureBuilderBookView(),
                        bestOfTheDayBook(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );



  }

  Widget whatAreYouReadingTodayText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.displayMedium,
          children: const [
            TextSpan(text: "What are you \nreading "),
            TextSpan(
              text: "today?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
          return SizedBox(
            height: 285,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return ReadingCardList(
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
                  addToFavorites: () {},
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

  Widget bestOfTheDayBook() {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Best of the ",
                    style: constant.kHeading2TextStyle.textTheme.bodyMedium),
                TextSpan(
                    text: "day",
                    style:
                        constant.kHeading2TextStyleBold.textTheme.bodyMedium),
              ],
            ),
          ),
          BestOfTheDayCard(size: size),
        ],
      ),
    );
  }
}
