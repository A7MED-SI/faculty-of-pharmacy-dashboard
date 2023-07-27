part of 'dashboard_bloc.dart';

enum StatisticsFetchingStatus { initial, loading, success, failed }

@immutable
class DashboardState {
  final StatisticsModel? statisticsModel;
  final StatisticsFetchingStatus statisticsFetchingStatus;
  final StatisticsNumbers? currentStatisticsNumbers;
  final int currentChosenValue;

  const DashboardState({
    this.statisticsModel,
    this.currentStatisticsNumbers,
    this.statisticsFetchingStatus = StatisticsFetchingStatus.initial,
    this.currentChosenValue = 0,
  });

  DashboardState copyWith({
    StatisticsModel? statisticsModel,
    StatisticsFetchingStatus? statisticsFetchingStatus,
    StatisticsNumbers? currentStatisticsNumbers,
    int? currentChosenValue,
  }) {
    return DashboardState(
      statisticsFetchingStatus:
          statisticsFetchingStatus ?? this.statisticsFetchingStatus,
      statisticsModel: statisticsModel ?? this.statisticsModel,
      currentStatisticsNumbers:
          currentStatisticsNumbers ?? this.currentStatisticsNumbers,
      currentChosenValue: currentChosenValue ?? this.currentChosenValue,
    );
  }
}
