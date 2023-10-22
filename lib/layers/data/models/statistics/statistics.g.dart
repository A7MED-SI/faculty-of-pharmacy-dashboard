// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticsModel _$StatisticsModelFromJson(Map<String, dynamic> json) =>
    StatisticsModel(
      thisMonth: StatisticsNumbers.fromJson(
          json['this_month'] as Map<String, dynamic>),
      thisSexMonth: StatisticsNumbers.fromJson(
          json['this_sex_month'] as Map<String, dynamic>),
      thisYear:
          StatisticsNumbers.fromJson(json['this_year'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatisticsModelToJson(StatisticsModel instance) =>
    <String, dynamic>{
      'this_month': instance.thisMonth.toJson(),
      'this_sex_month': instance.thisSexMonth.toJson(),
      'this_year': instance.thisYear.toJson(),
    };

StatisticsNumbers _$StatisticsNumbersFromJson(Map<String, dynamic> json) =>
    StatisticsNumbers(
      newUser: json['new_user'] as int,
      newSubscribeInSubject: json['new_subscribe_in_subject'] as int,
      newSubscribeInSemester: json['new_subscribe_in_semester'] as int,
      fromDate: json['from_date'] as String,
      toDate: json['to_date'] as String,
    );

Map<String, dynamic> _$StatisticsNumbersToJson(StatisticsNumbers instance) =>
    <String, dynamic>{
      'new_user': instance.newUser,
      'new_subscribe_in_subject': instance.newSubscribeInSubject,
      'new_subscribe_in_semester': instance.newSubscribeInSemester,
      'from_date': instance.fromDate,
      'to_date': instance.toDate,
    };
