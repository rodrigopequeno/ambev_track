import 'package:flutter_modular/flutter_modular.dart';

import '../../core/utils/duration_converter/duration_converter.dart';
import 'data/datasources/collect_local_data_source.dart';
import 'data/datasources/collect_remote_data_source.dart';
import 'data/repositories/collect_repository_impl.dart';
import 'domain/repositories/collect_repository.dart';
import 'domain/usecases/insert_new_collect.dart';
import 'domain/usecases/validate_geographic_coordinate.dart';
import 'presentation/cubit/add_collect_cubit.dart';
import 'presentation/pages/add_collect_page.dart';

class CollectModule extends Module {
  static const routerName = "/collect";

  @override
  final List<Bind> binds = [
    Bind.lazySingleton<CollectLocalDataSource>(
        (i) => CollectLocalDataSourceImpl(database: i.get())),
    Bind.lazySingleton<CollectRemoteDataSource>(
        (i) => CollectRemoteDataSourceImpl(service: i.get())),
    Bind.lazySingleton<CollectRepository>((i) => CollectRepositoryImpl(
        collectLocalDataSource: i.get(),
        collectRemoteDataSource: i.get(),
        networkInfo: i.get())),
    Bind.lazySingleton((i) => InsertNewCollect(repository: i.get())),
    Bind.lazySingleton((i) => ValidateGeographicCoordinate()),
    Bind.lazySingleton((i) => DurationConverter()),
    Bind.lazySingleton(
      (i) => AddCollectCubit(
        insertNewCollect: i.get(),
        validateGeographicCoordinate: i.get(),
        durationConverter: i.get(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      AddCollectPage.routerName,
      child: (_, args) => const AddCollectPage(),
    ),
  ];
}
