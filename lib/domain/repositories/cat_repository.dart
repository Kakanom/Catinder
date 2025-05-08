import '../entities/cat.dart';
// import '../../data/database/app_database.dart';

abstract class CatRepository {
  Future<List<Cat>> fetchCats();
  Future<void> likeCat(Cat cat);
  Future<void> removeCat(Cat cat);
  Future<List<Cat>> getLikedCats();
}
