import 'dart:convert';

import 'package:pharmacy_dashboard/layers/data/models/statistics/statistics.dart';

import '../../../core/constants/api/api_urls.dart';
import '../../../core/unified_api/get_api.dart';

class DashboardDataSource {
  Future<StatisticsModel> getAllStatistics(
      {Map<String, dynamic>? queryParams}) async {
    final getApi = GetApi<StatisticsModel>(
      uri: ApiUris.getAllStatisticsUri(queryParams: queryParams),
      fromJson: (json) {
        return StatisticsModel.fromJson(jsonDecode(json)['data']);
      },
      requestName: "Get All Statistics",
    );
    return await getApi.callRequest();
  }
}
