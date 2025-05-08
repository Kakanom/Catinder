import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/cat.dart';
import '../../domain/repositories/cat_repository.dart';
import '../services/cat_api_service.dart';
import '../database/app_database.dart';

class CatRepositoryImpl implements CatRepository {
  final CatApiService apiService;
  final AppDatabase database;
  final Connectivity connectivity;

  CatRepositoryImpl(this.apiService, this.database, this.connectivity);

  @override
  Future<List<Cat>> fetchCats() async {
    final connectivityResult = await connectivity.checkConnectivity();
    final isOffline = connectivityResult == ConnectivityResult.none;

    if (isOffline) {
      final likedCats = await database.getLikedCats();
      return likedCats;
    }

    try {
      final cats = await apiService.fetchCats();
      await database.saveCats(cats);
      return cats;
    } catch (e) {
      final likedCats = await database.getLikedCats();
      if (likedCats.isNotEmpty) {
        return likedCats;
      }
      rethrow;
    }
  }

  Future<void> likeCat(Cat cat) async {
    final updatedCat = Cat(
      id: cat.id,
      url: cat.url,
      breedName: cat.breedName,
      breedDescription: cat.breedDescription,
      likedAt: DateTime.now(),
    );
    await database.saveCat(updatedCat);
  }

  Future<void> removeCat(Cat cat) async {
    await database.removeCat(cat.id);
  }

  Future<List<Cat>> getLikedCats() async {
    return await database.getLikedCats();
  }
}
