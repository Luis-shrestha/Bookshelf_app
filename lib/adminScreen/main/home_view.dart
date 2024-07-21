import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/constant/constant.dart' as constant;
import '../controllers/MenuAppController.dart';
import '../dashboard/admin_dashboard_screen.dart';
import '../responsive.dart';
import 'components/side_menu.dart';

class HomeView extends StatelessWidget {

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
      ],
      child: HomeViewPage(),
    );
  }
}

class HomeViewPage extends StatefulWidget {

  const HomeViewPage({super.key,});

  @override
  State<HomeViewPage> createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      backgroundColor: constant.primaryColor,
      drawer: SideMenu(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(constant.bitmap),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (Responsive.isDesktop(context))
                      Expanded(
                        child: SideMenu(),
                      ),
                    Expanded(
                      flex: 5,
                      child: DashboardScreen(),
                    ),
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
