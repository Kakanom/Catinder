import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/database/app_database.dart';
import '../data/repositories/cat_repository.dart';
import '../data/services/cat_api_service.dart';
import '../domain/repositories/cat_repository.dart';
import '../domain/usecases/fetch_cats.dart';
import '../presentation/blocs/cat_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerSingleton<CatApiService>(CatApiService());
  getIt.registerSingleton<Connectivity>(Connectivity());
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  // Repositories
  getIt.registerSingleton<CatRepository>(CatRepositoryImpl(
      getIt<CatApiService>(), getIt<AppDatabase>(), getIt<Connectivity>()));

  // Use Cases
  getIt.registerSingleton<FetchCats>(FetchCats(getIt<CatRepository>()));

  // Blocs
  getIt.registerSingleton<CatBloc>(CatBloc(getIt<FetchCats>()));
}
