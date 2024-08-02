import 'package:flutter/material.dart';
import '../../utility/constant/constant.dart' as constant;
import '../authentication_screen/user_logout_screen.dart';
import '../main_screen/dashboard.dart';
import '../main_screen/explore_screen.dart';
import '../main_screen/favorite_screen.dart';
import '../main_screen/profile_screen.dart';


class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.home, 'title': 'Home', 'destination': const Dashboard()},
    {'icon': Icons.favorite, 'title': 'Favorites', 'destination': FavoriteScreen()},
    {'icon': Icons.explore, 'title': 'Explore', 'destination': const ExploreScreen()},
    {'icon': Icons.person, 'title': 'Profile', 'destination': const ProfileScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(constant.bitmap),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Text('TrekTrove'),
          ),
          for (var item in menuItems)
            ListTile(
              leading: Icon(item['icon']),
              title: Text(item['title']),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigator.pushNamed(context, item['destination']);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> item['destination']));
              },
            ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, 'Login');
              UserLogoutScreen.logout(context);
            },
          ),
        ],
      ),
    );
  }
}
