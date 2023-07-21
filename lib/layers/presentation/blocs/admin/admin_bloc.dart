import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/admin_repository.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/admin/toggle_admin_active.dart';

import '../../../data/models/login_response/login_response.dart';
import '../../../domain/use_cases/admin/add_admin.dart';
import '../../../domain/use_cases/admin/get_admins.dart';
import '../../../domain/use_cases/admin/update_admin.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(const AdminState()) {
    on<AdminsFetched>(_mapAdminsFetched);
    on<AdminActiveToggled>(_mapAdminActiveToggled);
    on<AdminAdded>(_mapAdminAdded);
    on<AdminUpdated>(_mapAdminUpdated);
  }
  final _getAdminsUseCase =
      GetAdminsUseCase(adminRepository: AdminRepositoryImplementaion());
  final _toggleAdminActiveUseCase =
      ToggleAdminActiveUseCase(adminRepository: AdminRepositoryImplementaion());
  final _addAdminUseCase =
      AddAdminUseCase(adminRepository: AdminRepositoryImplementaion());
  final _updateAdminUseCase =
      UpdateAdminUseCase(adminRepository: AdminRepositoryImplementaion());
  FutureOr<void> _mapAdminsFetched(
      AdminsFetched event, Emitter<AdminState> emit) async {
    emit(state.copyWith(adminsFetchingStatus: AdminsFetchingStatus.loading));
    final result = await _getAdminsUseCase(event.getAdminsParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(adminsFetchingStatus: AdminsFetchingStatus.failed));
      },
      (admins) async {
        emit(state.copyWith(
          adminsFetchingStatus: AdminsFetchingStatus.success,
          admins: admins,
        ));
      },
    );
  }

  FutureOr<void> _mapAdminActiveToggled(
      AdminActiveToggled event, Emitter<AdminState> emit) async {
    var adminIndex =
        state.admins.indexWhere((admin) => admin.id == event.adminId);
    var oldAdmin = state.admins[adminIndex];
    var newAdmin = Admin(
      id: oldAdmin.id,
      name: oldAdmin.name,
      username: oldAdmin.username,
      isActive: (oldAdmin.isActive! + 1) % 2,
      role: oldAdmin.role,
    );
    log("New Admin Activity ${newAdmin.isActive}");
    final admins = List.of(state.admins);
    admins[adminIndex] = newAdmin;
    emit(state.copyWith(admins: admins));
    final result = await _toggleAdminActiveUseCase(event.adminId);

    await result.fold(
      (l) async {
        admins[adminIndex] = oldAdmin;
        emit(state.copyWith(
            admins: admins, togglingStatus: TogglingStatus.failed));
        emit(state.copyWith(togglingStatus: TogglingStatus.initial));
      },
      (r) async {},
    );
  }

  FutureOr<void> _mapAdminAdded(
      AdminAdded event, Emitter<AdminState> emit) async {
    emit(state.copyWith(adminsFetchingStatus: AdminsFetchingStatus.loading));
    final result = await _addAdminUseCase(event.addAdminsParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            adminsFetchingStatus: AdminsFetchingStatus.success,
            addingStatus: AddingStatus.failed));
        emit(state.copyWith(addingStatus: AddingStatus.initial));
      },
      (admin) async {
        final admins = List.of(state.admins)..insert(0, admin);
        emit(state.copyWith(
            adminsFetchingStatus: AdminsFetchingStatus.success,
            addingStatus: AddingStatus.success,
            admins: admins));
        emit(state.copyWith(addingStatus: AddingStatus.initial));
      },
    );
  }

  FutureOr<void> _mapAdminUpdated(
      AdminUpdated event, Emitter<AdminState> emit) async {
    emit(state.copyWith(adminsFetchingStatus: AdminsFetchingStatus.loading));
    final result = await _updateAdminUseCase(event.updateAdminsParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            adminsFetchingStatus: AdminsFetchingStatus.success,
            updatingStatus: UpdatingStatus.failed));
        emit(state.copyWith(updatingStatus: UpdatingStatus.initial));
      },
      (admin) async {
        final adminIndex = state.admins.indexWhere(
          (admin) {
            return admin.id == event.updateAdminsParams.adminId;
          },
        );
        final admins = List.of(state.admins);
        admins[adminIndex] = admin;
        emit(state.copyWith(
            adminsFetchingStatus: AdminsFetchingStatus.success,
            updatingStatus: UpdatingStatus.success,
            admins: admins));
        emit(state.copyWith(updatingStatus: UpdatingStatus.initial));
      },
    );
  }
}
