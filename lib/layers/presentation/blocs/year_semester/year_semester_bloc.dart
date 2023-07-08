import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/year_semester_repositroy.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/year_semester/toggle_year_semester_active.dart';

import '../../../data/models/year_semester/year_semester.dart';
import '../../../domain/use_cases/year_semester/get_year_semesters.dart';

part 'year_semester_event.dart';
part 'year_semester_state.dart';

class YearSemesterBloc extends Bloc<YearSemesterEvent, YearSemesterState> {
  YearSemesterBloc() : super(const YearSemesterState()) {
    on<YearSemesterFetched>(_mapYearSemesterFetched);
    on<YearSemesterActiveToggled>(_mapYearSemesterActiveToggled);
  }
  final _getYearSemestersUseCase = GetYearSemestersUseCase(
      yearSemesterRepository: YearSemesterRepositoryImplementation());
  // ignore: unused_field
  final _toggleYearSemesterActiveUseCase = ToggleYearSemesterActiveUseCase(
      yearSemesterRepository: YearSemesterRepositoryImplementation());
  FutureOr<void> _mapYearSemesterFetched(
      YearSemesterFetched event, Emitter<YearSemesterState> emit) async {
    final result = await _getYearSemestersUseCase(event.getYearSemestersParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            yearSemestersFetchingStatus: YearSemestersFetchingStatus.failed));
      },
      (yearSemesters) async {
        emit(state.copyWith(
          yearSemestersFetchingStatus: YearSemestersFetchingStatus.success,
          yearSemesters: yearSemesters,
        ));
      },
    );
  }

  FutureOr<void> _mapYearSemesterActiveToggled(
      YearSemesterActiveToggled event, Emitter<YearSemesterState> emit) async {}
}
