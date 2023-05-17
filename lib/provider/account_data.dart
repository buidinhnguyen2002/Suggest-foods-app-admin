import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:suggest_food_app/model/account.dart';
import 'package:suggest_food_app/util/constants.dart';
import '../model/http_exception.dart';
import 'package:http/http.dart' as http;

class AccountData extends ChangeNotifier {
  double _balance = 0.0;

  double get balance => _balance;

  set balance(double value) {
    _balance = value;
    notifyListeners();
  }
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

   bool accountEmailIsExist(email) {
    for (var account in accounts) {
      if (account.email == email) return true;
    }
    return false;
  }

  // Chức năng sửa thông tin tài khoản
  // 8. Gọi API sửa thông tin tài khoản
  Future<void> updateAccount(String email, Account account) async {
    // var url =
    //     'https://suggest-food-app-default-rtdb.firebaseio.com/schedules/$userId.json?auth=$authToken';
    var url = '$apiUsers$accountId/$email.json?auth=$authToken';
    try {
      // final response = await http.get(Uri.parse(url));
      // final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // final List<Account> loadedAccounts = [];
      // if (extractedData == null) {
      //   return;
      // }
      // _accounts = loadedAccounts;
      // notifyListeners();
      await http.patch(Uri.parse(url),
      body: json.encode(account.toJson()));
    } catch (error) {
      // rethrow;
    }
  }
  // Chức năng xóa tài khoản
  // 5. Gọi API xóa tài khoản
      Future<void> deleteAccounts(String email) async {
    final url = '$apiUsers$accountId/$email.json?auth=$authToken';
    // final existingAccountsIndex =
    //     _accounts.indexWhere((account) => account.email == email);
    // Account? existingAccount = _accounts[existingAccountsIndex];
    // _accounts.removeAt(existingAccountsIndex);
    // notifyListeners();
    // final response = await http.delete(Uri.parse(url));
    // if (response.statusCode >= 400) {
    //   _accounts.insert(existingAccountsIndex, existingAccount);
    //   notifyListeners();
    //   throw HttpException('Could not delete account.');
    // }
    await http.delete(Uri.parse(url));
  }

// Chức năng thêm tài khoản mới
// 8. Gọi API tạo tài khoản mới
  Future<void> addAccount(Account account) async {
    final url = '$apiUsers$accountId.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': account.email,
          'password': account.password,
        }),
      );
      final responseData = json.decode(response.body);
      final newUser = Account(
          email: account.email,
          password: account.password);
      _accounts.add(newUser);
      notifyListeners();
  
    } catch (error) {
      throw error;
    }
  }
  Stream<List<Account>> getAccounts() {
    final url = '$apiUsers$accountId.json?auth=$authToken';
    return http.get(Uri.parse(url)).asStream().map((response) {
      final List<Account> loadedAccounts = [];
      final Map<String, dynamic>? responseData = json.decode(response.body);
      if (responseData == null) {
        return loadedAccounts;
      }
      responseData.forEach((accountId, accountData) {
        final account = Account.fromJson(accountData, accountId);
        loadedAccounts.add(account);
      });
      return loadedAccounts;
    });
  }

  Account findByEmail(String email) {
    return _accounts.firstWhere((account) => account.email == email);
  }

}