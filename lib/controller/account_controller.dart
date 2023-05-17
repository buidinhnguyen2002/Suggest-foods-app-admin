import 'package:flutter/cupertino.dart';
import 'package:suggest_food_app/model/account.dart';
import 'package:provider/provider.dart';
import 'package:suggest_food_app/provider/account_data.dart';

class AccountController {
  AccountController();
  Future<void> createAccount(BuildContext context, Account account) async {
    await Provider.of<AccountData>(context, listen: false)
        .addAccount(account);
  }

  Future<void> updateAccount(
      BuildContext context, String email, Account account) async {
    await Provider.of<AccountData>(context, listen: false)
        .updateAccount(email, account);
  }
  // Chức năng xóa tài khoản
// 4.2 Submit
  Future<void> deleteAccount(BuildContext context, String id) async {
    await Provider.of<AccountData>(context, listen: false).deleteAccounts(id);
  }
   // Chức thêm tài khoản mới || Chức năng sửa thông tin tài khoản
   // 7. Kiểm tra tài khoản vừa tạo || 7. Kiểm tra tài khoản vừa sửa
  // 7.1 gọi phương thức accountEmailIsExist để kiểm tra xem email đã tồn tại hay chưa
  bool checkAccountMail(BuildContext context, email) {
    return Provider.of<AccountData>(context, listen: false)
        .accountEmailIsExist(email);
  }
}
