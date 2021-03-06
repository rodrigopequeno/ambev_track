import '../../../../core/error/exceptions/server_exception.dart';
import '../../../../core/service/service.dart';
import '../models/collect_model.dart';

abstract class CollectRemoteDataSource {
  Future<void> insertNewCollect({required CollectModel collectModel});
}

const insertNewCollectPath = "/7bbc6148-ba08-4722-96d3-096b35b67fb4";

class CollectRemoteDataSourceImpl implements CollectRemoteDataSource {
  final Service service;

  CollectRemoteDataSourceImpl({
    required this.service,
  });

  @override
  Future<void> insertNewCollect({required CollectModel collectModel}) async {
    final response = await service.post(
      path: insertNewCollectPath,
      body: collectModel.toMap(),
    );
    if (response.statusCode != 200) {
      throw ServerException(
        response: response,
        error: response.statusMessage,
      );
    }
  }
}
