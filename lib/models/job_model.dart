import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uniestagios/core/datetime/datetime_conversion.dart';

@JsonSerializable()
class JobModel {
  String enterpriseName;
  String jobDescription;
  String profilePic;
  String cvPic;
  String city;
  DateTime? jobDate;
  bool available;
  String id;
  String enterpriseId;

  JobModel({
    this.enterpriseName = '',
    this.jobDescription = '',
    this.profilePic = '',
    this.city = '',
    this.cvPic = '',
    this.available = true,
    this.jobDate,
    this.id = '',
    this.enterpriseId = '',
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        enterpriseName: json['nomeEmpresa'] as String,
        jobDescription: json['descricaoVaga'] as String,
        profilePic: json['fotoPerfil'] as String,
        city: json['cidade'] as String,
        cvPic: json['fotoVaga'] as String,
        available: json['disponivel'] as bool,
        jobDate: dateTimeFromTimestamp(json['dataVaga'] as Timestamp?),
        id: json['id'] as String,
        enterpriseId: json['empresaId'] as String,
      );
}
