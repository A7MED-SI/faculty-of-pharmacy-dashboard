import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/layers/data/models/statistics/statistics.dart';

abstract class DashboardRepository {
  Future<Either<Failure, StatisticsModel>> getAllStatistics(
      {Map<String, dynamic>? params});
}
