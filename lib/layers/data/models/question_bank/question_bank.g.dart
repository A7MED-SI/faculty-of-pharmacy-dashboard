// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_bank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionBank _$QuestionBankFromJson(Map<String, dynamic> json) => QuestionBank(
      id: json['id'] as int,
      title: json['title'] as String,
      bankType: json['bank_type'] as int,
      isActive: json['is_active'] as int,
      chapterOrder: json['chapter_order'] as int?,
      yearOfExam: json['year_of_exam'] as String?,
      semesterOfExam: json['semester_of_exam'] as int?,
    );

Map<String, dynamic> _$QuestionBankToJson(QuestionBank instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'bank_type': instance.bankType,
      'is_active': instance.isActive,
      'chapter_order': instance.chapterOrder,
      'year_of_exam': instance.yearOfExam,
      'semester_of_exam': instance.semesterOfExam,
    };
