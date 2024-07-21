import 'package:flutter/material.dart';
import '../../../../../utility/constant/constant.dart' as constant;

class ContinueReadingCard extends StatelessWidget {
  final Size size;

  const ContinueReadingCard({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38.5),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 10),
            blurRadius: 33,
            color: const Color(0xFFD3D3D3).withOpacity(.84),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 20),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Crushing & Influence",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Gary Venchuk",
                            style: TextStyle(color: constant.kLightBlackColor),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Chapter 7 of 10",
                              style: TextStyle(fontSize: 10, color: constant.kLightBlackColor),
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                    Image.asset(
                      constant.book1,
                      width: 55,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 7,
              width: size.width * .65,
              decoration: BoxDecoration(
                color: constant.kProgressIndicator,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
