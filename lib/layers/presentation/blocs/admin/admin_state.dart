part of 'admin_bloc.dart';

enum AdminsFetchingStatus { initial, loading, success, failed }

enum TogglingStatus { initial, success, failed }

enum AddingStatus { initial, success, failed }

enum UpdatingStatus { initial, success, failed }

enum DeletingStatus { initial, success, failed }

@immutable
class AdminState {
  final AdminsFetchingStatus adminsFetchingStatus;
  final TogglingStatus togglingStatus;
  final AddingStatus addingStatus;
  final UpdatingStatus updatingStatus;
  final DeletingStatus deletingStatus;
  final List<Admin> admins;
  final String? errorMessage;

  const AdminState({
    this.adminsFetchingStatus = AdminsFetchingStatus.initial,
    this.togglingStatus = TogglingStatus.initial,
    this.addingStatus = AddingStatus.initial,
    this.updatingStatus = UpdatingStatus.initial,
    this.deletingStatus = DeletingStatus.initial,
    this.admins = const [],
    this.errorMessage,
  });

  AdminState copyWith({
    AdminsFetchingStatus? adminsFetchingStatus,
    List<Admin>? admins,
    TogglingStatus? togglingStatus,
    AddingStatus? addingStatus,
    UpdatingStatus? updatingStatus,
    DeletingStatus? deletingStatus,
    String? errorMessage,
  }) {
    return AdminState(
      admins: admins ?? this.admins,
      adminsFetchingStatus: adminsFetchingStatus ?? this.adminsFetchingStatus,
      togglingStatus: togglingStatus ?? this.togglingStatus,
      addingStatus: addingStatus ?? this.addingStatus,
      updatingStatus: updatingStatus ?? this.updatingStatus,
      deletingStatus: deletingStatus ?? this.deletingStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
