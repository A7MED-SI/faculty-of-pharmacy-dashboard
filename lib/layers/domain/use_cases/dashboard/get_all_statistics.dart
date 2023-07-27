import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/core/use_case/use_case.dart';
import 'package:pharmacy_dashboard/layers/data/models/statistics/statistics.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/dashboard_repository.dart';

class GetAllStatisticsUseCase implements UseCase<StatisticsModel, NoParams> {
  final DashboardRepository dashboardRepository;

  GetAllStatisticsUseCase({required this.dashboardRepository});
  @override
  Future<Either<Failure, StatisticsModel>> call(NoParams params) async {
    return await dashboardRepository.getAllStatistics();
  }
}
