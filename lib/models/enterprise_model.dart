class EnterpriseModel {
  String? id;
  String? socialReason;
  String? cnpj;
  String? email;
  String? password;
  String? phone;
  String? area;
  String? state;
  String? city;
  String? photo;

  EnterpriseModel({
    this.id,
    this.socialReason,
    this.cnpj,
    this.email,
    this.password,
    this.area,
    this.phone,
    this.state,
    this.city,
    this.photo,
  });

  factory EnterpriseModel.fromJson(Map<String, dynamic> json) =>
      EnterpriseModel(
        id: json['id'] as String? ?? '',
        socialReason: json['razaosocial'] as String? ?? '',
        cnpj: json['cnpj'] as String? ?? '',
        email: json['email'] as String? ?? '',
        area: json['area'] as String? ?? '',
        phone: json['telefone'] as String? ?? '',
        state: json['estado'] as String? ?? '',
        city: json['cidade'] as String? ?? '',
        photo: json['foto'] as String? ?? '',
      );
}
