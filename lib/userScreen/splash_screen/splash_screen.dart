import 'dart:async';
import 'package:flutter/material.dart';
import '../../../utility/constant/constant.dart' as constant;
import '../authentication_screen/user_login_register_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                const UserLoginRegisterView(),
            ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(constant.bitmap),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(constant.bookGif,height: 150,),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineMedium,
                children: const [
                  TextSpan(
                    text: "Book",
                  ),
                  TextSpan(
                    text: "Shelf.",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
