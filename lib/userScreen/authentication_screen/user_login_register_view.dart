import 'package:flutter/material.dart';
import 'package:shelf/userScreen/authentication_screen/user_register_page.dart';
import 'package:shelf/utility/widget/header/header.dart';
import '../../../utility/constant/constant.dart' as constant;
import 'user_login_screen.dart';

class UserLoginRegisterView extends StatelessWidget {
  const UserLoginRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: constant.kBackGroundColor,
        body: SafeArea(
          child: Column(
            children: [
              AppHeader(title: 'User'),
              TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                    color: constant.primaryColor,
                ),
                unselectedLabelColor: constant.kBlackColor,

                labelColor: Colors.white,
                tabs: <Widget>[
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                        ),
                        Image.asset(
                          constant.login,
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Register"),
                        Image.asset(
                          constant.register,
                          height: 25,
                          color: constant.kIconColor,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: const TabBarView(
                  children: <Widget>[
                    UserLoginScreen(),
                    UserRegisterPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
