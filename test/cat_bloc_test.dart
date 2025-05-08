import 'package:Catinder/domain/repositories/cat_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:Catinder/domain/entities/cat.dart';
import 'package:Catinder/domain/usecases/fetch_cats.dart';
import 'package:Catinder/presentation/blocs/cat_bloc.dart';
import 'package:Catinder/presentation/blocs/cat_event.dart';
import 'package:Catinder/presentation/blocs/cat_state.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';


class MockFetchCats extends Mock implements FetchCats {}
class MockCatRepository extends Mock implements CatRepository {}
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late CatBloc catBloc;
  late MockFetchCats mockFetchCats;
  late MockCatRepository mockCatRepository;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockFetchCats = MockFetchCats();
    mockCatRepository = MockCatRepository();
    mockConnectivity = MockConnectivity();
    catBloc = CatBloc(mockFetchCats, repository: mockCatRepository);

    registerFallbackValue(Cat(id: '', url: ''));
  });

  tearDown(() {
    catBloc.close();
  });

  final testCat = Cat(id: '1', url: 'http://example.com/cat1.jpg');
  final testCats = [testCat];
  final likedCat = Cat(
    id: '2',
    url: 'http://example.com/cat2.jpg',
    likedAt: DateTime(2025, 5, 8),
  );

  group('CatBloc', () {
    blocTest<CatBloc, CatState>(
      'emits cats when fetch is successful',
      build: () {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.wifi);
        when(() => mockFetchCats()).thenAnswer((_) async => testCats);
        when(() => mockCatRepository.getLikedCats())
            .thenAnswer((_) async => []);
        return catBloc;
      },
      act: (bloc) => bloc.add(FetchCatsEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const CatState(isLoading: true, error: null),
        CatState(cats: testCats, isLoading: false),
      ],
    );

    blocTest<CatBloc, CatState>(
      'emits liked cats in offline mode',
      build: () {
        when(() => mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => ConnectivityResult.none);
        when(() => mockCatRepository.getLikedCats())
            .thenAnswer((_) async => [likedCat]);
        return catBloc;
      },
      act: (bloc) => bloc.add(FetchCatsEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const CatState(isLoading: true, error: null),
        CatState(
          cats: [likedCat],
          likedCats: [likedCat],
          likeCount: 1,
          isLoading: false,
        ),
      ],
    );

    blocTest<CatBloc, CatState>(
      'handles right swipe correctly',
      build: () {
        when(() => mockCatRepository.likeCat(testCat))
            .thenAnswer((_) async {});
        when(() => mockCatRepository.getLikedCats())
            .thenAnswer((_) async => [testCat]);
        return catBloc;
      },
      seed: () => CatState(cats: testCats),
      act: (bloc) => bloc.add(SwipeCatEvent(0, CardSwiperDirection.right)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        CatState(
          cats: testCats,
          likedCats: [testCat],
          likeCount: 1,
          streakCount: 1,
        ),
      ],
    );
  });
}