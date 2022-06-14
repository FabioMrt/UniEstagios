import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uniestagios/core/datetime/datetime_conversion.dart';

@JsonSerializable()
class JobModel {
  String jobName;
  String jobArea;
  String enterpriseName;
  String profilePic;
  String cvPic;
  String city;
  DateTime? jobDate;
  bool available;
  String id;
  String enterpriseId;
  String enterpriseEmail;

  JobModel({
    this.jobName = '',
    this.jobArea = '',
    this.enterpriseName = '',
    this.profilePic = '',
    this.city = '',
    this.cvPic = '',
    this.available = true,
    this.jobDate,
    this.id = '',
    this.enterpriseId = '',
    this.enterpriseEmail = '',
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        jobName: json['nomeVaga'] as String,
        jobArea: json['area'] as String,
        enterpriseName: json['nomeEmpresa'] as String,
        profilePic: json['fotoPerfil'] as String,
        city: json['cidade'] as String,
        cvPic: json['fotoVaga'] as String,
        available: json['disponivel'] as bool,
        jobDate: dateTimeFromTimestamp(json['dataVaga'] as Timestamp?),
        id: json['id'] as String,
        enterpriseId: json['empresaId'] as String,
        enterpriseEmail: json['emailEmpresa'] as String,
      );
}
