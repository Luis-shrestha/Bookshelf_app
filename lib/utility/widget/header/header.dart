import 'package:flutter/material.dart';
import '../../../utility/constant/constant.dart' as constant;

class AppHeader extends StatelessWidget {
  final String title;
  const AppHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: constant.kBackGroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("BookShelf ${title}", style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20
          ),),
        ],
      ),
    );
  }
}
