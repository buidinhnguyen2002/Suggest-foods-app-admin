import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suggest_food_app/view/screens/admin_screen.dart';
import 'package:suggest_food_app/view/screens/manage_account_screen.dart';

import '../../provider/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: CircleAvatar(
                child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
              ),
              title: const Text(
                "Admin",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AdminScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text('Manage foods'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text('Manage Accounts'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManageAccountScreen.routeName); // 1. Chọn chức năng quản lý tài khoản
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
