import 'package:flutter/material.dart';
import '../../utility/constant/constant.dart' as constant;

class AbstractBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    // Background color
    paint.color = constant.primaryColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Wavy shape 1
    Path path1 = Path();
    path1.moveTo(0, size.height * 0.6);
    path1.quadraticBezierTo(
      size.width * 0.25, size.height * 0.65,
      size.width * 0.5, size.height * 0.6,
    );
    path1.quadraticBezierTo(
      size.width * 0.75, size.height * 0.55,
      size.width, size.height * 0.6,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    paint.color = Colors.white12.withOpacity(0.1);
    canvas.drawPath(path1, paint);

    // Wavy shape 2
    Path path2 = Path();
    path2.moveTo(0, size.height * 0.7);
    path2.quadraticBezierTo(
      size.width * 0.2, size.height * 0.3,
      size.width * 0.4, size.height * 0.55,
    );
    path2.quadraticBezierTo(
      size.width * 0.95, size.height * 0.95,
      size.width, size.height * 0.45,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    paint.color = Colors.white12.withOpacity(0.1);
    canvas.drawPath(path2, paint);

    // Wavy shape 3
    Path path3 = Path();
    path3.moveTo(0, size.height * 0.1);
    path3.quadraticBezierTo(
      size.width * .12, size.height * .45,
      size.width * .5, size.height * 0.3,
    );
    path3.quadraticBezierTo(
      size.width * 0.7, size.height * 0.25,
      size.width, size.height * 0.15,
    );
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();

    paint.color = Colors.white12.withOpacity(0.1);
    canvas.drawPath(path3, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
