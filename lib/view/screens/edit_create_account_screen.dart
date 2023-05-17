import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:suggest_food_app/controller/account_controller.dart';
import 'package:suggest_food_app/model/account.dart';
import 'package:suggest_food_app/provider/account_data.dart';
import 'package:suggest_food_app/view/screens/account_detail_screen.dart';

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
  var _form = GlobalKey<FormState>();
  var _isInit = true;
  var _initValues = {
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
            .findByEmail(accountId as String);
        _initValues = {
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
      email: _initValues['email'].toString() == ''
          ? ''
          : _initValues['email'].toString(),
      password: _initValues['password'].toString() == ''
          ? ''
          : _initValues['password'].toString(),
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
    if (_editAccount.email != '') {
      await accountController.updateAccount(
          context, _editAccount.email.toString(), _editAccount);
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
    Navigator.of(context).pop();
    showAccountDetailScreen();
  }

  void showAccountDetailScreen() {
    Navigator.of(context).pushNamed(
      AccountDetailScreen.routeName,
      arguments: _editAccount.email != ''
          ? _editAccount.email
          : Provider.of<AccountData>(context, listen: false)
              .accounts
              .last
              .email,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _editAccount.email != null ? 'Edit Account' : 'Create Account'),
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
                    TextFormField(
                      initialValue: _initValues['title'].toString(),
                      decoration: InputDecoration(labelText: 'Titile'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        // 7.1. Kiểm tra xem tên đã tồn tại hay chưa
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
                          email: _editAccount.email,
                          password: _editAccount.password,
                        );
                      },
                    ),
                    Container(
                      height: deviceSize.height - 70 - 16 * 2 - 20 - 200,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            offset: const Offset(0, 2),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      // Tạo tài khoản hoặc update tài khoản
                      onPressed: _saveForm,
                      child: Text(
                        _editAccount.email != null ? 'Update' : 'Create',
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
