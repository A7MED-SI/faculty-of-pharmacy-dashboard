// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_semester.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearSemester _$YearSemesterFromJson(Map<String, dynamic> json) => YearSemester(
      year: json['year'] as int,
      semesters: (json['semesters'] as List<dynamic>)
          .map((e) => Semester.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$YearSemesterToJson(YearSemester instance) =>
    <String, dynamic>{
      'year': instance.year,
      'semesters': instance.semesters,
    };

Semester _$SemesterFromJson(Map<String, dynamic> json) => Semester(
      id: json['id'] as int,
      subjectYear: json['subject_year'] as int?,
      semester: json['semester'] as int,
      subjects: (json['subjects'] as List<dynamic>)
          .map((e) => Subject.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SemesterToJson(Semester instance) => <String, dynamic>{
      'id': instance.id,
      'subject_year': instance.subjectYear,
      'semester': instance.semester,
      'subjects': instance.subjects,
    };
