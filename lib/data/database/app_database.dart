import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import '../../domain/entities/cat.dart';
part 'app_database.g.dart';

class CatEntries extends Table {
  TextColumn get id => text().withLength(min: 1, max: 50)();
  TextColumn get url => text()();
  TextColumn get breedName => text().nullable()();
  TextColumn get breedDescription => text().nullable()();
  DateTimeColumn get likedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [CatEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Cat>> getLikedCats() async {
    return (select(catEntries)..where((c) => c.likedAt.isNotNull()))
        .map((row) => Cat(
              id: row.id,
              url: row.url,
              breedName: row.breedName,
              breedDescription: row.breedDescription,
              likedAt: row.likedAt,
            ))
        .get();
  }

  Future<void> saveCat(Cat cat) async {
    await into(catEntries).insertOnConflictUpdate(CatEntriesCompanion(
      id: Value(cat.id),
      url: Value(cat.url),
      breedName: Value(cat.breedName),
      breedDescription: Value(cat.breedDescription),
      likedAt: Value(cat.likedAt),
    ));
  }

  Future<void> removeCat(String id) async {
    await (delete(catEntries)..where((c) => c.id.equals(id))).go();
  }

  Future<void> saveCats(List<Cat> catList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(
        catEntries,
        catList.map((cat) => CatEntriesCompanion(
              id: Value(cat.id),
              url: Value(cat.url),
              breedName: Value(cat.breedName),
              breedDescription: Value(cat.breedDescription),
              likedAt: Value(cat.likedAt),
            )),
      );
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'catinder.sqlite'));
    return NativeDatabase(file);
  });
}
