part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class PageIndexChanged extends HomeEvent {
  final int newIndex;

  PageIndexChanged(this.newIndex);
}

class RailExtendingToggled extends HomeEvent {

  RailExtendingToggled();
}
