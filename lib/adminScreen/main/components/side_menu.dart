import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utility/constant/constant.dart' as constant;
import '../../authenticationScreen/admin_logout_screen.dart';
import '../../dashboard/components/manage_users.dart';
import '../../dashboard/components/see_all_books.dart';
import '../../dashboard/components/upload_book_update.dart';
import '../home_view.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final ValueNotifier<bool> isAdminView =
      ValueNotifier<bool>(true); // Change to false for user view
  void switchView() {
    isAdminView.value = !isAdminView.value;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 3,
      surfaceTintColor: Colors.black,
      backgroundColor: constant.primaryColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                SizedBox(
                  child: Image.asset("assets/icons/books.png"),
                  height: 100,
                ),
                Text(
                  "BookShelf",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/adminSide/icons/menu_dashboard.svg",
            press: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeView()));
            },
          ),
          DrawerListTile(
            title: "See All Books",
            svgSrc: "assets/adminSide/icons/menu_tran.svg",
            press: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SeeAllBooks()));
            },
          ),
          DrawerListTile(
            title: "Manage Users",
            svgSrc: "assets/adminSide/icons/menu_task.svg",
            press: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ManageUsersView()));
            },
          ),
          DrawerListTile(
            title: "Upload Books",
            svgSrc: "assets/adminSide/icons/menu_doc.svg",
            press: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UploadBookUpdatedView()));
            },
          ),
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/adminSide/icons/menu_doc.svg",
            press: () {
              Navigator.of(context).pop(); // Close the dialog
              AdminLogoutScreen.logout(context);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black87),
      ),
    );
  }
}
