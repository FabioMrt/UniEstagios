import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uniestagios/core/datetime/datetime_conversion.dart';

@JsonSerializable()
class CandidateModel {
  String id;
  String jobTitle;
  String internCity;
  String internEmail;
  String internId;
  String internName;
  bool answered;
  DateTime? sendDate;
  String enterpriseId;
  String internImage;
  String internResume;
  String internUniversity;

  CandidateModel({
    this.id = '',
    this.jobTitle = '',
    this.internCity = '',
    this.internEmail = '',
    this.internId = '',
    this.internName = '',
    this.sendDate,
    this.answered = true,
    this.enterpriseId = '',
    this.internImage = '',
    this.internResume = '',
    this.internUniversity = '',
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) => CandidateModel(
        id: json['id'] as String,
        jobTitle: json['tituloVaga'] as String,
        internCity: json['cidadeEstagiario'] as String,
        internEmail: json['emailEstagiario'] as String,
        internName: json['nomeEstagiario'] as String,
        internImage: json['imagemEstagiario'] as String,
        internResume: json['imagemCurriculo'] as String,
        internUniversity: json['universidadeEstagiario'] as String,
        sendDate: dateTimeFromTimestamp(json['dataEnvio'] as Timestamp?),
        answered: json['respondido'] as bool,
        internId: json['estagiarioId'] as String,
        enterpriseId: json['empresaId'] as String,
      );
}
