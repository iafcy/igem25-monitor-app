import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monitor_mobile_app/screens/settings.dart';

class MenuItem {
  final String title;
  final Widget icon;
  final Function(BuildContext context) onTap;

  MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, this.title = "TailoGuard Monitor"});

  List<MenuItem> get menuItems => [
      MenuItem(
        title: 'Settings',
        icon: SvgPicture.asset('assets/icons/settings.svg',),
        onTap: (context) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ),
          );
        },
      ),
    ];
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black, 
          fontSize: 24, 
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            icon: SvgPicture.asset('assets/icons/ellipsis-vertical.svg',),
            offset: Offset(-8, 8),
            onSelected: (value) {
              final selectedItem =
                  menuItems.firstWhere((item) => item.title == value);
              selectedItem.onTap(context);
            },
            itemBuilder: (BuildContext context) {
              return menuItems.map((menuItem) {
                return PopupMenuItem<String>(
                  value: menuItem.title,
                  child: Row(
                    children: [
                      menuItem.icon,
                      const SizedBox(width: 8),
                      Text(menuItem.title),
                    ],
                  ),
                );
              }).toList();
            }
          ),
        )
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
