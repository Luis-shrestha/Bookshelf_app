import '../../../utility/constant/constant.dart' as constant;
import 'package:flutter/material.dart';

class TwoSideRoundedButton extends StatelessWidget {
  final String text;
  final double radius;
  final VoidCallback onTap;

  const TwoSideRoundedButton({
    super.key,
    required this.text,
    this.radius = 29,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: constant.kBlackColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
