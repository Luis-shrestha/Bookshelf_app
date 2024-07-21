import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shelf/userScreen/main_screen/profile_screen.dart';
import 'dashboard.dart';
import 'explore_screen.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Dashboard();

  final List<Widget> screens = [
    const Dashboard(),
    const ExploreScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  void selectTab(int index) {
    setState(() {
      currentScreen = screens[index];
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: GNav(
            gap: 5,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: Colors.grey,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInExpo,
            iconSize: 24,
            tabActiveBorder: Border.all(color: Colors.black, width: 1),
            tabBorderRadius: 20,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.indigo.withOpacity(0.1),
            onTabChange: (index){
              setState(() {
                selectTab(index);
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.explore,
                text: 'explore',
              ),
              GButton(
                icon: Icons.favorite,
                text: 'favorite',
              ),
              GButton(
                icon: Icons.person,
                text: 'profile',
              )
            ]
        ),
      ),
    );
  }
}
