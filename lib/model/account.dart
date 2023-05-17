class Account{
  final String? email;
  final String? password;

  Account({
      this.email,
      this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json, String email) {
    return Account(
      email: json['email'],
      password: json['password'],
    );
  }
}