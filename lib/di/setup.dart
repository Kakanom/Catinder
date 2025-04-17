import 'package:get_it/get_it.dart';
import '../data/repositories/cat_repository.dart';
import '../data/services/cat_api_service.dart';
import '../domain/repositories/cat_repository.dart';
import '../domain/usecases/fetch_cats.dart';
import '../presentation/blocs/cat_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerSingleton<CatApiService>(CatApiService());

  // Repositories
  getIt.registerSingleton<CatRepository>(CatRepositoryImpl(getIt<CatApiService>()));

  // Use Cases
  getIt.registerSingleton<FetchCats>(FetchCats(getIt<CatRepository>()));

  // Blocs
  getIt.registerSingleton<CatBloc>(CatBloc(getIt<FetchCats>()));
}
