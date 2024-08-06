import 'package:flutter/material.dart';
import 'package:shelf/utility/widget/header/header.dart';
import '../../../utility/constant/constant.dart' as constant;
import 'admin_login_Screen.dart';
import 'admin_register_screen.dart';

class AdminLoginRegisterView extends StatelessWidget {
  const AdminLoginRegisterView({super.key});

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
              AppHeader(title: 'Admin',),
              TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
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
                  /*Tab(
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
                  ),*/
                ],
              ),
              Expanded(
                child: const TabBarView(
                  children: <Widget>[
                    AdminLoginScreen(),
                    // AdminRegisterPage(),
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
