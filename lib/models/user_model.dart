class UserModel {
  String id;
  String name;
  String email;
  String password;
  String phone;

  UserModel({
    this.id = '',
    this.name = '',
    this.email = '',
    this.password = '',
    this.phone = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['nome'] as String,
        email: json['email'] as String,
        phone: json['telefone'] as String,
      );
}
