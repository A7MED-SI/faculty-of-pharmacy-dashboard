import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/core/unified_api/handling_exception.dart';
import 'package:pharmacy_dashboard/layers/data/data_sources/dashboard.dart';
import 'package:pharmacy_dashboard/layers/data/models/statistics/statistics.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImplementation implements DashboardRepository {
  final _dashboardDataSource = DashboardDataSource();
  @override
  Future<Either<Failure, StatisticsModel>> getAllStatistics(
      {Map<String, dynamic>? params}) async {
    return await HandlingExceptionManager.wrapHandling<StatisticsModel>(
      tryCall: () async {
        final response = await _dashboardDataSource.getAllStatistics();
        return Right(response);
      },
    );
  }
}
