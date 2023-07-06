part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent {}

class AdminsFetched extends AdminEvent {
  final GetAdminsParams getAdminsParams;

  AdminsFetched({required this.getAdminsParams});
}

class AdminAdded extends AdminEvent {
  final AddAdminParams addAdminsParams;

  AdminAdded({required this.addAdminsParams});
}

class AdminUpdated extends AdminEvent {
  final UpdateAdminParams updateAdminsParams;

  AdminUpdated({required this.updateAdminsParams});
}

class AdminActiveToggled extends AdminEvent {
  final int adminId;

  AdminActiveToggled({required this.adminId});
}