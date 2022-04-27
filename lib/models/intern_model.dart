class InternModel {
  String? id;
  String? age;
  String? course;
  String? university;
  String? state;
  String? city;

  InternModel({
    this.id,
    this.age,
    this.course,
    this.university,
    this.state,
    this.city,
  });

  factory InternModel.fromJson(Map<String, dynamic> json) => InternModel(
        id: json['id'] as String? ?? '',
        age: json['idade'] as String? ?? '',
        course: json['curso'] as String? ?? '',
        university: json['universidade'] as String? ?? '',
        state: json['estado'] as String? ?? '',
        city: json['cidade'] as String? ?? '',
      );
}
