import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/core/use_case/use_case.dart';
import 'package:pharmacy_dashboard/layers/data/models/statistics/statistics.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/dashboard_repository.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/dashboard/get_all_statistics.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<StatisticsFetched>(_mapStatisticsFetched);
    on<StatisticsNumbersValueChanged>(_mapStatisticsNumbersValueChanged);
  }
  final _getAllStatisticsUseCase = GetAllStatisticsUseCase(
      dashboardRepository: DashboardRepositoryImplementation());

  FutureOr<void> _mapStatisticsFetched(
      StatisticsFetched event, Emitter<DashboardState> emit) async {
    final result = await _getAllStatisticsUseCase(NoParams());

    await result.fold(
      (l) async {
        emit(state.copyWith(
            statisticsFetchingStatus: StatisticsFetchingStatus.failed));
      },
      (statistics) async {
        emit(state.copyWith(
          statisticsFetchingStatus: StatisticsFetchingStatus.success,
          statisticsModel: statistics,
          currentStatisticsNumbers: statistics.thisMonth,
        ));
      },
    );
  }

  FutureOr<void> _mapStatisticsNumbersValueChanged(
      StatisticsNumbersValueChanged event, Emitter<DashboardState> emit) async {
    if (state.currentChosenValue == event.value) {
      return;
    }
    late StatisticsNumbers statisticsNumbers;
    switch (event.value) {
      case 0:
        {
          statisticsNumbers = state.statisticsModel!.thisMonth;
          break;
        }
      case 1:
        {
          statisticsNumbers = state.statisticsModel!.thisSexMonth;
          break;
        }
      case 2:
        {
          statisticsNumbers = state.statisticsModel!.thisYear;
          break;
        }
      default:
        statisticsNumbers = state.statisticsModel!.thisMonth;
    }
    emit(state.copyWith(
      currentChosenValue: event.value,
      currentStatisticsNumbers: statisticsNumbers,
    ));
  }
}
