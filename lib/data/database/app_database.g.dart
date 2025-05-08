// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CatEntriesTable extends CatEntries
    with TableInfo<$CatEntriesTable, CatEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _breedNameMeta =
      const VerificationMeta('breedName');
  @override
  late final GeneratedColumn<String> breedName = GeneratedColumn<String>(
      'breed_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _breedDescriptionMeta =
      const VerificationMeta('breedDescription');
  @override
  late final GeneratedColumn<String> breedDescription = GeneratedColumn<String>(
      'breed_description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _likedAtMeta =
      const VerificationMeta('likedAt');
  @override
  late final GeneratedColumn<DateTime> likedAt = GeneratedColumn<DateTime>(
      'liked_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, url, breedName, breedDescription, likedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cat_entries';
  @override
  VerificationContext validateIntegrity(Insertable<CatEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('breed_name')) {
      context.handle(_breedNameMeta,
          breedName.isAcceptableOrUnknown(data['breed_name']!, _breedNameMeta));
    }
    if (data.containsKey('breed_description')) {
      context.handle(
          _breedDescriptionMeta,
          breedDescription.isAcceptableOrUnknown(
              data['breed_description']!, _breedDescriptionMeta));
    }
    if (data.containsKey('liked_at')) {
      context.handle(_likedAtMeta,
          likedAt.isAcceptableOrUnknown(data['liked_at']!, _likedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      breedName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}breed_name']),
      breedDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}breed_description']),
      likedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}liked_at']),
    );
  }

  @override
  $CatEntriesTable createAlias(String alias) {
    return $CatEntriesTable(attachedDatabase, alias);
  }
}

class CatEntry extends DataClass implements Insertable<CatEntry> {
  final String id;
  final String url;
  final String? breedName;
  final String? breedDescription;
  final DateTime? likedAt;
  const CatEntry(
      {required this.id,
      required this.url,
      this.breedName,
      this.breedDescription,
      this.likedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || breedName != null) {
      map['breed_name'] = Variable<String>(breedName);
    }
    if (!nullToAbsent || breedDescription != null) {
      map['breed_description'] = Variable<String>(breedDescription);
    }
    if (!nullToAbsent || likedAt != null) {
      map['liked_at'] = Variable<DateTime>(likedAt);
    }
    return map;
  }

  CatEntriesCompanion toCompanion(bool nullToAbsent) {
    return CatEntriesCompanion(
      id: Value(id),
      url: Value(url),
      breedName: breedName == null && nullToAbsent
          ? const Value.absent()
          : Value(breedName),
      breedDescription: breedDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(breedDescription),
      likedAt: likedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(likedAt),
    );
  }

  factory CatEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatEntry(
      id: serializer.fromJson<String>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      breedName: serializer.fromJson<String?>(json['breedName']),
      breedDescription: serializer.fromJson<String?>(json['breedDescription']),
      likedAt: serializer.fromJson<DateTime?>(json['likedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'url': serializer.toJson<String>(url),
      'breedName': serializer.toJson<String?>(breedName),
      'breedDescription': serializer.toJson<String?>(breedDescription),
      'likedAt': serializer.toJson<DateTime?>(likedAt),
    };
  }

  CatEntry copyWith(
          {String? id,
          String? url,
          Value<String?> breedName = const Value.absent(),
          Value<String?> breedDescription = const Value.absent(),
          Value<DateTime?> likedAt = const Value.absent()}) =>
      CatEntry(
        id: id ?? this.id,
        url: url ?? this.url,
        breedName: breedName.present ? breedName.value : this.breedName,
        breedDescription: breedDescription.present
            ? breedDescription.value
            : this.breedDescription,
        likedAt: likedAt.present ? likedAt.value : this.likedAt,
      );
  CatEntry copyWithCompanion(CatEntriesCompanion data) {
    return CatEntry(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      breedName: data.breedName.present ? data.breedName.value : this.breedName,
      breedDescription: data.breedDescription.present
          ? data.breedDescription.value
          : this.breedDescription,
      likedAt: data.likedAt.present ? data.likedAt.value : this.likedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatEntry(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('breedName: $breedName, ')
          ..write('breedDescription: $breedDescription, ')
          ..write('likedAt: $likedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, url, breedName, breedDescription, likedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatEntry &&
          other.id == this.id &&
          other.url == this.url &&
          other.breedName == this.breedName &&
          other.breedDescription == this.breedDescription &&
          other.likedAt == this.likedAt);
}

class CatEntriesCompanion extends UpdateCompanion<CatEntry> {
  final Value<String> id;
  final Value<String> url;
  final Value<String?> breedName;
  final Value<String?> breedDescription;
  final Value<DateTime?> likedAt;
  final Value<int> rowid;
  const CatEntriesCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.breedName = const Value.absent(),
    this.breedDescription = const Value.absent(),
    this.likedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatEntriesCompanion.insert({
    required String id,
    required String url,
    this.breedName = const Value.absent(),
    this.breedDescription = const Value.absent(),
    this.likedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        url = Value(url);
  static Insertable<CatEntry> custom({
    Expression<String>? id,
    Expression<String>? url,
    Expression<String>? breedName,
    Expression<String>? breedDescription,
    Expression<DateTime>? likedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (breedName != null) 'breed_name': breedName,
      if (breedDescription != null) 'breed_description': breedDescription,
      if (likedAt != null) 'liked_at': likedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? url,
      Value<String?>? breedName,
      Value<String?>? breedDescription,
      Value<DateTime?>? likedAt,
      Value<int>? rowid}) {
    return CatEntriesCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      breedName: breedName ?? this.breedName,
      breedDescription: breedDescription ?? this.breedDescription,
      likedAt: likedAt ?? this.likedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (breedName.present) {
      map['breed_name'] = Variable<String>(breedName.value);
    }
    if (breedDescription.present) {
      map['breed_description'] = Variable<String>(breedDescription.value);
    }
    if (likedAt.present) {
      map['liked_at'] = Variable<DateTime>(likedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatEntriesCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('breedName: $breedName, ')
          ..write('breedDescription: $breedDescription, ')
          ..write('likedAt: $likedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatEntriesTable catEntries = $CatEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [catEntries];
}

typedef $$CatEntriesTableCreateCompanionBuilder = CatEntriesCompanion Function({
  required String id,
  required String url,
  Value<String?> breedName,
  Value<String?> breedDescription,
  Value<DateTime?> likedAt,
  Value<int> rowid,
});
typedef $$CatEntriesTableUpdateCompanionBuilder = CatEntriesCompanion Function({
  Value<String> id,
  Value<String> url,
  Value<String?> breedName,
  Value<String?> breedDescription,
  Value<DateTime?> likedAt,
  Value<int> rowid,
});

class $$CatEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CatEntriesTable> {
  $$CatEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breedName => $composableBuilder(
      column: $table.breedName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breedDescription => $composableBuilder(
      column: $table.breedDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get likedAt => $composableBuilder(
      column: $table.likedAt, builder: (column) => ColumnFilters(column));
}

class $$CatEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatEntriesTable> {
  $$CatEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breedName => $composableBuilder(
      column: $table.breedName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breedDescription => $composableBuilder(
      column: $table.breedDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get likedAt => $composableBuilder(
      column: $table.likedAt, builder: (column) => ColumnOrderings(column));
}

class $$CatEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatEntriesTable> {
  $$CatEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get breedName =>
      $composableBuilder(column: $table.breedName, builder: (column) => column);

  GeneratedColumn<String> get breedDescription => $composableBuilder(
      column: $table.breedDescription, builder: (column) => column);

  GeneratedColumn<DateTime> get likedAt =>
      $composableBuilder(column: $table.likedAt, builder: (column) => column);
}

class $$CatEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CatEntriesTable,
    CatEntry,
    $$CatEntriesTableFilterComposer,
    $$CatEntriesTableOrderingComposer,
    $$CatEntriesTableAnnotationComposer,
    $$CatEntriesTableCreateCompanionBuilder,
    $$CatEntriesTableUpdateCompanionBuilder,
    (CatEntry, BaseReferences<_$AppDatabase, $CatEntriesTable, CatEntry>),
    CatEntry,
    PrefetchHooks Function()> {
  $$CatEntriesTableTableManager(_$AppDatabase db, $CatEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String?> breedName = const Value.absent(),
            Value<String?> breedDescription = const Value.absent(),
            Value<DateTime?> likedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CatEntriesCompanion(
            id: id,
            url: url,
            breedName: breedName,
            breedDescription: breedDescription,
            likedAt: likedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String url,
            Value<String?> breedName = const Value.absent(),
            Value<String?> breedDescription = const Value.absent(),
            Value<DateTime?> likedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CatEntriesCompanion.insert(
            id: id,
            url: url,
            breedName: breedName,
            breedDescription: breedDescription,
            likedAt: likedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CatEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CatEntriesTable,
    CatEntry,
    $$CatEntriesTableFilterComposer,
    $$CatEntriesTableOrderingComposer,
    $$CatEntriesTableAnnotationComposer,
    $$CatEntriesTableCreateCompanionBuilder,
    $$CatEntriesTableUpdateCompanionBuilder,
    (CatEntry, BaseReferences<_$AppDatabase, $CatEntriesTable, CatEntry>),
    CatEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatEntriesTableTableManager get catEntries =>
      $$CatEntriesTableTableManager(_db, _db.catEntries);
}
