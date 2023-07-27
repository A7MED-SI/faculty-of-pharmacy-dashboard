part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class StatisticsFetched extends DashboardEvent {}

class StatisticsNumbersValueChanged extends DashboardEvent {
  final int value;

  StatisticsNumbersValueChanged(this.value);
}
