part of 'admin_bloc.dart';

enum AdminsFetchingStatus { initial, loading, success, failed }

enum TogglingStatus { initial, success, failed }

enum AddingStatus { initial, success, failed }

enum UpdatingStatus { initial, success, failed }

@immutable
class AdminState {
  final AdminsFetchingStatus adminsFetchingStatus;
  final TogglingStatus togglingStatus;
  final AddingStatus addingStatus;
  final UpdatingStatus updatingStatus;
  final List<Admin> admins;

  const AdminState({
    this.adminsFetchingStatus = AdminsFetchingStatus.initial,
    this.togglingStatus = TogglingStatus.initial,
    this.addingStatus = AddingStatus.initial,
    this.updatingStatus = UpdatingStatus.initial,
    this.admins = const [],
  });

  AdminState copyWith({
    AdminsFetchingStatus? adminsFetchingStatus,
    List<Admin>? admins,
    TogglingStatus? togglingStatus,
    AddingStatus? addingStatus,
    UpdatingStatus? updatingStatus,
  }) {
    return AdminState(
      admins: admins ?? this.admins,
      adminsFetchingStatus: adminsFetchingStatus ?? this.adminsFetchingStatus,
      togglingStatus: togglingStatus ?? this.togglingStatus,
      addingStatus: addingStatus ?? this.addingStatus,
      updatingStatus: updatingStatus ?? this.updatingStatus,
    );
  }
}
