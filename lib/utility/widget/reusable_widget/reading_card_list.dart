import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../supports/FavoriteManage/favorite_manager.dart';
import '../../../supports/IdGenerator/id_generator.dart';
import 'two_side_rounded_button.dart'; // Adjust the import as needed
import '../../constant/constant.dart' as constant;

class ReadingCardList extends StatefulWidget {
  final String image;
  final String title;
  final String auth;
  final VoidCallback pressRead;
  final VoidCallback detail;
  final String id;
  final String heroTag; // Add the heroTag parameter

  ReadingCardList({
    super.key,
    required this.image,
    required this.title,
    required this.auth,
    required this.pressRead,
    required this.detail,
    required this.id,
    required this.heroTag, // Initialize the heroTag parameter
  });

  @override
  State<ReadingCardList> createState() => _ReadingCardListState();
}

class _ReadingCardListState extends State<ReadingCardList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(widget.id),
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
            child: Hero(
              tag: widget.heroTag, // Use the heroTag parameter here
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.image,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                  height: 150,
                ),
              ),
            ),
          ),
          Positioned(
            top: 35,
            right: 10,
            child: Consumer<FavoriteManager>(
              builder: (context, favoriteManager, child) {
                final isFavorite = favoriteManager.favorites.contains(widget.id);
                return IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  color: Colors.red,
                  onPressed: () {
                    if (isFavorite) {
                      favoriteManager.removeFavorite(widget.id);
                    } else {
                      favoriteManager.addFavorite(widget.id);
                    }
                  },
                );
              },
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
