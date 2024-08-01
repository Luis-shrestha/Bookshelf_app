import 'package:flutter/material.dart';
import 'package:shelf/utility/widget/reusable_widget/two_side_rounded_button.dart';
import '../../constant/constant.dart' as constant;

class ReadingCardListSecond extends StatefulWidget {
  final String image;
  final String title;
  final String auth;
  final VoidCallback pressRead;
  final VoidCallback detail;

  const ReadingCardListSecond({
    super.key,
    required this.image,
    required this.title,
    required this.auth,
    required this.pressRead,
    required this.detail,
  });

  @override
  State<ReadingCardListSecond> createState() => _ReadingCardListSecondState();
}

class _ReadingCardListSecondState extends State<ReadingCardListSecond> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, bottom: 10, right: 24),
      height: 225,
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
            top: 45,
            left: 25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Set the border radius here
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
            child: Row(
              children: [
                Text(isFavorite ? "remove from favorite" : "add to favorite",),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 120,
            left: 150,
            child: SizedBox(
              height: 85,
              width: 202,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                      "Title: ${widget.title}\nAuthor: ${widget.auth}",
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
