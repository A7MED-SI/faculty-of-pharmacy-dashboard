// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subject _$SubjectFromJson(Map<String, dynamic> json) => Subject(
      id: json['id'] as int,
      title: json['title'] as String,
      isActive: json['is_active'] as int? ?? 1,
      semester:
          Semester.fromJson(json['year_semester'] as Map<String, dynamic>),
      chapterBanks: (json['subject_chapters'] as List<dynamic>?)
          ?.map((e) => QuestionBank.fromJson(e as Map<String, dynamic>))
          .toList(),
      previousExams: (json['question_exams'] as List<dynamic>?)
          ?.map((e) => QuestionBank.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'is_active': instance.isActive,
      'year_semester': instance.semester.toJson(),
      'question_exams': instance.previousExams?.map((e) => e.toJson()).toList(),
      'subject_chapters':
          instance.chapterBanks?.map((e) => e.toJson()).toList(),
    };
