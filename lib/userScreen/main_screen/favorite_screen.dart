import 'package:flutter/material.dart';
import '../../../../utility/customBackground/abstract_background.dart';
import '../../../../utility/customBackground/bottom_circular_clipper.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../model/repository/upload_repo/fetch_data.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  final FetchData fetchData = FetchData();
  late Future<List<List<Map<String, dynamic>>>> dataFuture;

  @override
  void initState() {
    super.initState();
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
                  width: MediaQuery.of(context).size.width,
                  child: ClipPath(
                    clipper: BottomCircularClipper(),
                    child: CustomPaint(
                      painter: AbstractBackgroundPainter(),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 120,
                  child: Text(
                    "favorite Screen",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
