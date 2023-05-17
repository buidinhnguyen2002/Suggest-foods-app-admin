import 'package:flutter/material.dart';
import 'package:suggest_food_app/controller/account_controller.dart';
import 'package:suggest_food_app/view/screens/edit_create_account_screen.dart';
import '../../provider/account_data.dart';
import 'package:suggest_food_app/view/widget/account_item.dart';
import 'package:provider/provider.dart';
import '../widget/app_drawer.dart';

class ManageAccountScreen extends StatelessWidget {
  static const routeName = '/manage-account';

// 2. Hiển thị trang quản lý tài khoản
  const ManageAccountScreen({super.key});
  Future<void> _refreshAccounts(BuildContext context) async {
    await Provider.of<AccountData>(context, listen: false)
        .getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        title: Text('My accounts'),
         // Chức năng thêm tài khoản mới - 3. Chọn button Tạo
         // Chức năng sửa thông tin tài khoản - 3. Chọn button Sửa
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditCreateAccountScreen.routeName); 
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      // Chức năng xóa tài khoản - 6. Hiển thị trang quản lý tài khoản mới được cập nhật
      body: FutureBuilder(
        future: _refreshAccounts(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<AccountData>(
                builder: (context, accountData, child) => Container(
                  color: Colors.white,
                  width: deviceSize.width,
                  height: deviceSize.height,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ListView.builder(
                    itemBuilder: (context, index) => AccountItem(
                      email: accountData.accounts[index].email,
                      password: accountData.accounts[index].password,
                    ),
                    itemCount: accountData.accounts.length,
                  ),
                ),
              ),
      ),
    );
  }
}
