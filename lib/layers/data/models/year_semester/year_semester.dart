import 'package:json_annotation/json_annotation.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject/subject.dart';
part 'year_semester.g.dart';

@JsonSerializable(explicitToJson: true)
class YearSemester {
  final int year;
  final List<Semester> semesters;

  YearSemester({
    required this.year,
    required this.semesters,
  });

  factory YearSemester.fromJson(Map<String, dynamic> json) {
    return _$YearSemesterFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$YearSemesterToJson(this);
  }

  YearSemester copyWith({
    int? year,
    List<Semester>? semesters,
  }) {
    return YearSemester(
        year: year ?? this.year, semesters: semesters ?? this.semesters);
  }

  String get arabicName {
    switch (year) {
      case 1:
        return "السنة الأولى";
      case 2:
        return "السنة الثانية";
      case 3:
        return "السنة الثالثة";
      case 4:
        return "السنة الرابعة";
      case 5:
        return "السنة الخامسة";
      default:
        return "";
    }
  }
}

@JsonSerializable(explicitToJson: true)
class Semester {
  final int id;
  @JsonKey(name: 'subject_year')
  final int? subjectYear;
  final int semester;
  @JsonKey(name: 'is_active')
  final int? isActive;
  final List<Subject>? subjects;

  Semester({
    required this.id,
    this.subjectYear,
    required this.semester,
    required this.subjects,
    this.isActive = 1,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return _$SemesterFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SemesterToJson(this);
  }

  Semester copyWith({
    int? id,
    int? subjectYear,
    int? semester,
    int? isActive,
    List<Subject>? subjects,
  }) {
    return Semester(
      id: id ?? this.id,
      semester: semester ?? this.semester,
      subjects: subjects ?? this.subjects,
      isActive: isActive ?? this.isActive,
      subjectYear: subjectYear ?? this.subjectYear,
    );
  }

  String get semesterArabicName {
    switch (semester) {
      case 1:
        return "الفصل الأول";
      case 2:
        return "الفصل الثاني";
      default:
        return "";
    }
  }

  String get yearArabicName {
    switch (subjectYear) {
      case 1:
        return "السنة الأولى";
      case 2:
        return "السنة الثانية";
      case 3:
        return "السنة الثالثة";
      case 4:
        return "السنة الرابعة";
      case 5:
        return "السنة الخامسة";
      default:
        return "";
    }
  }
}
