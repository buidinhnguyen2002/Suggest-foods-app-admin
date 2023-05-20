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
        title: Text('Admin Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            'Welcome to Admin Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Điều hướng đến trang báo cáo
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportScreen()),
              );
            },
            child: Text('View Reports'),
          ),
        ],
      ),
    );
  }
}class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Center(
        child: Text(
          'Reports will be displayed here',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
