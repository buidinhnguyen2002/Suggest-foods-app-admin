import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suggest_food_app/controller/account_controller.dart';
import 'package:suggest_food_app/view/screens/edit_create_account_screen.dart';

import 'package:suggest_food_app/controller/account_controller.dart';

class AccountItem extends StatefulWidget {
  String? id;
  String? email;
  String? password;

  AccountItem(
      {super.key,this.id, this.email, this.password});

  @override
  State<AccountItem> createState() => _AccountItemState();
}

class _AccountItemState extends State<AccountItem> {
  final AccountController accountController = AccountController();
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
    Navigator.of(context).pop();
  }

 Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.email != null ? widget.email as String: ''),
        subtitle: Text(widget.password != null ? widget.password!: ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              padding: EdgeInsets.all(0),
              style: IconButton.styleFrom(
                padding: EdgeInsets.all(0),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EditCreateAccountScreen.routeName,
                    arguments: widget.id);
              },
              // Chức năng sửa thông tin tài khoản - 3. Chọn icon Sửa
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: Text("Delete"),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    children: [ // 4. Hiển thị hộp thoại xác nhận xóa tài khoản
                      const Text('Are you sure you want to delete account?'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 4.1.1. Đóng hộp thoại
                            },
                            child: Text('No'), // 4.1. Chọn button No
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await accountController
                                    .deleteAccount(context, widget.id!)
                                    .then((_) => showSnackBar(
                                        context, 'Deleting successful'));
                              } catch (e) {
                                showSnackBar(context, 'Deleting failed!');
                              }
                            },
                            child: Text('Yes'), // 4.2. Chọn button Yes
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              // Chức năng xóa tài khoản - 3. Chọn icon Xóa
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
