part of 'ads_bloc.dart';

@immutable
abstract class AdsEvent {}

class AdsFetched extends AdsEvent {}

class AdAdded extends AdsEvent {
  final AddAdParams addAdParams;

  AdAdded({required this.addAdParams});
}

class AdDeleted extends AdsEvent {
  final int adId;

  AdDeleted({required this.adId});
}

class AdActiveToggled extends AdsEvent {
  final int adId;

  AdActiveToggled({required this.adId});
}

class AdUpdated extends AdsEvent {
  final UpdateAdParams updateAdParams;

  AdUpdated({required this.updateAdParams});
}
