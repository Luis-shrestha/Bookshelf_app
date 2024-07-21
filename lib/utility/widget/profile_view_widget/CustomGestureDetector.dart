import 'package:flutter/material.dart';

class CustomGestureDetector extends StatelessWidget{
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final IconData icon;
  final Color? iconColor;
  final Color? titleColor;
  final Color? subtitleColor;

  const CustomGestureDetector({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.icon,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
  }): super(key:key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SizedBox(
                child: Icon(
                  icon,
                  size: 30,
                  color: iconColor ?? Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: titleColor ?? Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: subtitleColor ??
                          Theme.of(context).textTheme.bodySmall!.color,
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}