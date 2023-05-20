import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:suggest_food_app/model/account.dart';
import 'package:suggest_food_app/util/constants.dart';
import 'package:suggest_food_app/model/http_exception.dart';
import 'package:http/http.dart' as http;

class AccountData extends ChangeNotifier {
  List<Account> _accounts = [
    Account(
      email: 'abc@gmail.com',
      password: 'abcd',
    )
  ];
  final String? authToken;
  final String? accountId;
  AccountData(this._accounts, {this.authToken, this.accountId});
  List<Account> get accounts {
    return [..._accounts];
  }

Future<void> fetchAndSetAccount() async{
//  var url = '$apiUsers$accountId.json?auth=$authToken';
 var url = '$apiUsers.json?auth=$authToken';
    try {
       final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print("${extractedData}");
      final List<Account> loadedAccounts = [];
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((accountId, accountData) { 
        loadedAccounts.add(
          Account(id: accountId,
            email: accountData['email'],
            password: accountData['password'])
        );
      });
      _accounts = loadedAccounts;
      notifyListeners();
} catch(error){
  // rethrow;
}
}

   bool accountEmailIsExist(email) {
    for (var account in accounts) {
      if (account.email == email) return true;
    }
    return false;
  }

  Account findById(String id) {
    return _accounts.firstWhere((account) => account.id == id);
  }

  // Chức năng sửa thông tin tài khoản
  // 8. Gọi API sửa thông tin tài khoản
  Future<void> updateAccount(String id, Account account) async {
    // var url =
    //     'https://suggest-food-app-default-rtdb.firebaseio.com/schedules/$userId.json?auth=$authToken';
      final accountIndex =
        _accounts.indexWhere((account) => account.id == id);
    if (accountIndex > -1) {
      var url = '$apiUsers/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
        body: json.encode({
          'email': account.email,
          'password': account.password
        }));
        _accounts[accountIndex] = account;
      notifyListeners();
    }
    else{
      print('...');
    }
  }
  
  // Chức năng xóa tài khoản
  // 5. Gọi API xóa tài khoản
      Future<void> deleteAccounts(String id) async {
        print("$id:id");
    final url = '$apiUsers/$id.json?auth=$authToken';
    final existingAccountIndex =
        _accounts.indexWhere((account) => account.id == id);
    Account? existingAccount = _accounts[existingAccountIndex];
    _accounts.removeAt(existingAccountIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _accounts.insert(existingAccountIndex, existingAccount);
      notifyListeners();
      throw HttpException('Could not delete account.');
    }
  }

// Chức năng thêm tài khoản mới
// 8. Gọi API tạo tài khoản mới
  Future<void> addAccount(Account account) async {
   var url = '$apiUsers.json?auth=$authToken';
    try {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': account.email,
        'password': account.password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("${account.email}alll");
      final newUser = Account(
        id: responseData['name'],
        email: account.email,
        password: account.password,
      );

      print('Tài khoản mới:');
      print('ID: ${newUser.id}');
      print('Email: ${newUser.email}');
      print('Password: ${newUser.password}');
    } else {
      print('Thêm tài khoản thất bại. Mã phản hồi: ${response.statusCode}');
    }
  } catch (error) {
    rethrow;
  }
  }
}