import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<PageIndexChanged>(_mapPageIndexChanged);
    on<RailExtendingToggled>(_mapRailExtendingToggled);
  }

  FutureOr<void> _mapPageIndexChanged(
      PageIndexChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedIndex: event.newIndex));
  }

  FutureOr<void> _mapRailExtendingToggled(
      RailExtendingToggled event, Emitter<HomeState> emit) {
    emit(state.copyWith(isExtended: !state.isExtended));
  }
}
