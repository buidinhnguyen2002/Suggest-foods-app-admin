import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suggest_food_app/controller/account_controller.dart';
import 'package:suggest_food_app/model/account.dart';
import 'package:suggest_food_app/provider/account_data.dart';

class EditCreateAccountScreen extends StatefulWidget {
  static const routeName = '/edit-create-account';
  const EditCreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<EditCreateAccountScreen> createState() =>
      _EditCreateAccountScreenState();
}

class _EditCreateAccountScreenState extends State<EditCreateAccountScreen> {
  final AccountController accountController = AccountController();

  var _editAccount = Account(
    email: '',
    password: '',
  );
  // ignore: prefer_final_fields
  var _form = GlobalKey<FormState>();
  var _isInit = true;
  var _initValues = {
    'id': '',
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final accountId = ModalRoute.of(context)!.settings.arguments;
      if (accountId != null) {
        _editAccount = Provider.of<AccountData>(context, listen: false)
            .findById(accountId as String);
        _initValues = {
          'id': _editAccount.id!,
          'email': _editAccount.email!,
          'password': _editAccount.password!,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void setFinalEditedAccount() {
    _editAccount = Account(
      id: _initValues['id'].toString() == '' ? '' : _initValues['id'].toString(),
      email: _editAccount.email,
      password: _editAccount.password,
    );
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    setFinalEditedAccount();
    setState(() {
      _isLoading = true;
    });
    if (_editAccount.id != '') {
      await accountController.updateAccount(
          context, _editAccount.id.toString(), _editAccount);
    } else {
      try {
        await accountController.createAccount(context, _editAccount);
      } catch (error) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred'),
            content: const Text('Something went wrong.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

// Chức năng thêm tài khoản: 4. Hiển thị trang tạo tài khoản mới
// Chức năng sửa thông tin tài khoản: 4. Hiển thị trang chỉnh sửa thông tin tài khoản
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          
            _editAccount.id != null ? 'Edit Account' : 'Create Account'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    // Chức năng thêm tài khoản: 5. Nhập các thông tin cần thiết vào các trường
                    // Chức năng sửa thông tin tài khoản: 5. Chỉnh sửa các thông tin tài khoản cần thiết
                    TextFormField(
                      initialValue: _initValues['email'].toString(),
                      decoration: InputDecoration(labelText: 'Email'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        // 7.1. Kiểm tra xem email đã tồn tại hay chưa
                        if (AccountController().checkAccountMail(
                            context, value)) {
                          // 7.1.1. Email đã tồn tại
                          // 7.1.1.1. Hiển thị lỗi email đã tồn tại
                          return 'Email is exist';
                        }
                        // 7.1.2. Email chưa tồn tại
                        return null;
                      },
                      onSaved: (value) {
                        _editAccount = Account(
                          email: value,
                          password: _editAccount.password,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['password'].toString(),
                      decoration: InputDecoration(labelText: 'Password'),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editAccount = Account(
                          email: _editAccount.email,
                          password: value,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      // Chức năng thêm tài khoản: 6. Nhấn button Create 
                      // Chức năng sửa thông tin tài khoản: 6. Nhấn button Update
                      onPressed: _saveForm,
                      child: Text(
                        _editAccount.id != null ? 'Update' : 'Create',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
