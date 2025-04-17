import '../../domain/entities/cat.dart';
import '../../domain/repositories/cat_repository.dart';
import '../services/cat_api_service.dart';
import '../models/cat.dart';

class CatRepositoryImpl implements CatRepository {
  final CatApiService apiService;

  CatRepositoryImpl(this.apiService);

  @override
  Future<List<Cat>> fetchCats() async {
    return await apiService.fetchCats();
  }
}
