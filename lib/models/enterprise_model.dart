class EnterpriseModel {
  String? id;
  String? socialReason;
  String? cnpj;
  String? email;
  String? password;
  String? phone;
  String? state;
  String? city;

  EnterpriseModel({
    this.id,
    this.socialReason,
    this.cnpj,
    this.email,
    this.password,
    this.phone,
    this.state,
    this.city,
  });

  factory EnterpriseModel.fromJson(Map<String, dynamic> json) =>
      EnterpriseModel(
        id: json['id'] as String? ?? '',
        socialReason: json['razaosocial'] as String? ?? '',
        cnpj: json['cnpj'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['telefone'] as String? ?? '',
        state: json['estado'] as String? ?? '',
        city: json['cidade'] as String? ?? '',
      );
}
