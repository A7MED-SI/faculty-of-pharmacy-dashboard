part of 'home_bloc.dart';

@immutable
class HomeState {
  final int selectedIndex;
  final bool isExtended;

  const HomeState({
    this.selectedIndex = 0,
    this.isExtended = false,
  });

  HomeState copyWith({
    int? selectedIndex,
    bool? isExtended,
  }) {
    return HomeState(
      isExtended: isExtended ?? this.isExtended,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
