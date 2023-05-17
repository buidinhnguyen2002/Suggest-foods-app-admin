import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suggest_food_app/provider/auth.dart';
import 'package:suggest_food_app/view/screens/edit_create_account_screen.dart';
import 'package:suggest_food_app/view/screens/admin_screen.dart';
import 'package:suggest_food_app/view/screens/auth_screen.dart';
import 'package:suggest_food_app/view/screens/manage_account_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key?key}):super(key:key);
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: 'My demo',
          theme: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: Colors.green,
            accentColor: Colors.white,
          ),
          home: auth.isAuth ? AdminScreen() : AuthScreen(),
          routes: {
         AdminScreen.routeName: (context) => AdminScreen(),
            ManageAccountScreen.routeName: (context) => ManageAccountScreen(),
            EditCreateAccountScreen.routeName: (context) => EditCreateAccountScreen(),
          },
        ),
      ),
    );
  }
}
