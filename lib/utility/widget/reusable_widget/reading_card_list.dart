import 'package:flutter/material.dart';
import 'package:shelf/utility/widget/reusable_widget/two_side_rounded_button.dart';
import '../../constant/constant.dart' as constant;

class ReadingCardList extends StatefulWidget {
  final String image;
  final String title;
  final String auth;
  final VoidCallback pressRead;
  final VoidCallback addToFavorites;
  final VoidCallback detail;

  const ReadingCardList({
    super.key,
    required this.image,
    required this.title,
    required this.auth,
    required this.pressRead,
    required this.detail,
    required this.addToFavorites,
  });

  @override
  State<ReadingCardList> createState() => _ReadingCardListState();
}

class _ReadingCardListState extends State<ReadingCardList> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, bottom: 40),
      height: 245,
      width: 202,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 221,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(29),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 33,
                    color: constant.kShadowColor,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              // Set the border radius here
              child: Image.network(
                widget.image,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
                height: 150,
              ),
            ),
          ),
          Positioned(
            top: 35,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: widget.addToFavorites,
            ),
          ),
          Positioned(
            top: 160,
            child: SizedBox(
              height: 85,
              width: 202,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                      "Title: ${widget.title}\n Author: ${widget.auth}",
                      style: const TextStyle(
                        color: constant.kBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: widget.detail,
                        child: Container(
                          width: 101,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: const Text("Details"),
                        ),
                      ),
                      Expanded(
                        child: TwoSideRoundedButton(
                          text: "Read",
                          onTap: widget.pressRead,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
