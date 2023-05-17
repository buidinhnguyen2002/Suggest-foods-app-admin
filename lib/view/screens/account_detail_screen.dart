import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suggest_food_app/provider/account_data.dart';

// Chức năng thêm tài khoản mới - 9. Hiển thị trang thông tin chi tiết tài khoản mới được tạo
// Chức năng sửa thông tin tài khoản - 9. Hiển thị trang thông tin chi tiết tài khoản mới được chỉnh sửa
class AccountDetailScreen extends StatelessWidget {
  static const routeName = '/account-detail';
  const AccountDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final deviceSize = MediaQuery.of(context).size;
    final account = Provider.of<AccountData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(account.accountId!),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
    );
  }
}
