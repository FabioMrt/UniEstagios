class InternModel {
  String? id;
  String? name;
  String? age;
  String? course;
  String? university;
  String? state;
  String? city;
  String? cv;
  String? photo;

  InternModel({
    this.id,
    this.name,
    this.age,
    this.course,
    this.university,
    this.state,
    this.city,
    this.cv,
    this.photo,
  });

  factory InternModel.fromJson(Map<String, dynamic> json) => InternModel(
        id: json['id'] as String? ?? '',
        name: json['nome'] as String? ?? '',
        age: json['idade'] as String? ?? '',
        course: json['curso'] as String? ?? '',
        university: json['universidade'] as String? ?? '',
        state: json['estado'] as String? ?? '',
        city: json['cidade'] as String? ?? '',
        cv: json['curriculo'] as String? ?? '',
        photo: json['fotoPerfil'] as String? ?? '',
      );
}
