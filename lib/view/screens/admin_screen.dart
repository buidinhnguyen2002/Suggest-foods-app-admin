import 'dart:math';

import 'package:flutter/material.dart';
import './manage_account_screen.dart';
import 'package:suggest_food_app/view/widget/app_drawer.dart';
import 'package:suggest_food_app/view/widget/bottom_navigationbar_item.dart'
    as BottomNavigationBarItem;
import '../../util/constants.dart';

class AdminScreen extends StatelessWidget {
  static const routeName = '/admin';
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        title: Text('Home'),
      ),
      body: Container(
        color: Colors.white,
        width: deviceSize.width,
        height: deviceSize.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Menu Today',
              style: TextStyle(
                color: Color.fromARGB(255, 145, 199, 136),
                fontWeight: FontWeight.w600,
                fontSize: 25,
                height: 1.4,
              ),
              textAlign: TextAlign.left,
            ),
            ManageAccountScreen(),
          ],
        ),
      ),
    );
  }
}
