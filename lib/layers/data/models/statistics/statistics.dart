import 'package:json_annotation/json_annotation.dart';
part 'statistics.g.dart';

@JsonSerializable(explicitToJson: true)
class StatisticsModel {
  @JsonKey(name: 'this_month')
  final StatisticsNumbers thisMonth;
  @JsonKey(name: 'this_sex_month')
  final StatisticsNumbers thisSexMonth;
  @JsonKey(name: 'this_year')
  final StatisticsNumbers thisYear;

  StatisticsModel({
    required this.thisMonth,
    required this.thisSexMonth,
    required this.thisYear,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return _$StatisticsModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StatisticsModelToJson(this);
  }
}

@JsonSerializable()
class StatisticsNumbers {
  @JsonKey(name: 'new_user')
  final int newUser;
  @JsonKey(name: 'new_subscribe_in_subject')
  final int newSubscribeInSubject;
  @JsonKey(name: 'new_subscribe_in_semester')
  final int newSubscribeInSemester;
  @JsonKey(name: 'from_date')
  final String fromDate;
  @JsonKey(name: 'to_date')
  final String toDate;

  StatisticsNumbers({
    required this.newUser,
    required this.newSubscribeInSubject,
    required this.newSubscribeInSemester,
    required this.fromDate,
    required this.toDate,
  });

  factory StatisticsNumbers.fromJson(Map<String, dynamic> json) {
    return _$StatisticsNumbersFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StatisticsNumbersToJson(this);
  }
}
