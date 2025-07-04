// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, date, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final String name;
  final DateTime date;
  final DateTime createdAt;
  const Event(
      {required this.id,
      required this.name,
      required this.date,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      name: Value(name),
      date: Value(date),
      createdAt: Value(createdAt),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Event copyWith(
          {int? id, String? name, DateTime? date, DateTime? createdAt}) =>
      Event(
        id: id ?? this.id,
        name: name ?? this.name,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
      );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, date, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.name == this.name &&
          other.date == this.date &&
          other.createdAt == this.createdAt);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime date,
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        date = Value(date);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime>? date,
      Value<DateTime>? createdAt}) {
    return EventsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DancersTable extends Dancers with TableInfo<$DancersTable, Dancer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DancersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _firstMetDateMeta =
      const VerificationMeta('firstMetDate');
  @override
  late final GeneratedColumn<DateTime> firstMetDate = GeneratedColumn<DateTime>(
      'first_met_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _archivedAtMeta =
      const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, notes, firstMetDate, createdAt, isArchived, archivedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dancers';
  @override
  VerificationContext validateIntegrity(Insertable<Dancer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('first_met_date')) {
      context.handle(
          _firstMetDateMeta,
          firstMetDate.isAcceptableOrUnknown(
              data['first_met_date']!, _firstMetDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('archived_at')) {
      context.handle(
          _archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(
              data['archived_at']!, _archivedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dancer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dancer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      firstMetDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}first_met_date']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      archivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}archived_at']),
    );
  }

  @override
  $DancersTable createAlias(String alias) {
    return $DancersTable(attachedDatabase, alias);
  }
}

class Dancer extends DataClass implements Insertable<Dancer> {
  final int id;
  final String name;
  final String? notes;
  final DateTime? firstMetDate;
  final DateTime createdAt;
  final bool isArchived;
  final DateTime? archivedAt;
  const Dancer(
      {required this.id,
      required this.name,
      this.notes,
      this.firstMetDate,
      required this.createdAt,
      required this.isArchived,
      this.archivedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || firstMetDate != null) {
      map['first_met_date'] = Variable<DateTime>(firstMetDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  DancersCompanion toCompanion(bool nullToAbsent) {
    return DancersCompanion(
      id: Value(id),
      name: Value(name),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      firstMetDate: firstMetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(firstMetDate),
      createdAt: Value(createdAt),
      isArchived: Value(isArchived),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Dancer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dancer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      firstMetDate: serializer.fromJson<DateTime?>(json['firstMetDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'firstMetDate': serializer.toJson<DateTime?>(firstMetDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isArchived': serializer.toJson<bool>(isArchived),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Dancer copyWith(
          {int? id,
          String? name,
          Value<String?> notes = const Value.absent(),
          Value<DateTime?> firstMetDate = const Value.absent(),
          DateTime? createdAt,
          bool? isArchived,
          Value<DateTime?> archivedAt = const Value.absent()}) =>
      Dancer(
        id: id ?? this.id,
        name: name ?? this.name,
        notes: notes.present ? notes.value : this.notes,
        firstMetDate:
            firstMetDate.present ? firstMetDate.value : this.firstMetDate,
        createdAt: createdAt ?? this.createdAt,
        isArchived: isArchived ?? this.isArchived,
        archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
      );
  Dancer copyWithCompanion(DancersCompanion data) {
    return Dancer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      firstMetDate: data.firstMetDate.present
          ? data.firstMetDate.value
          : this.firstMetDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dancer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('firstMetDate: $firstMetDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, notes, firstMetDate, createdAt, isArchived, archivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dancer &&
          other.id == this.id &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.firstMetDate == this.firstMetDate &&
          other.createdAt == this.createdAt &&
          other.isArchived == this.isArchived &&
          other.archivedAt == this.archivedAt);
}

class DancersCompanion extends UpdateCompanion<Dancer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> notes;
  final Value<DateTime?> firstMetDate;
  final Value<DateTime> createdAt;
  final Value<bool> isArchived;
  final Value<DateTime?> archivedAt;
  const DancersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.firstMetDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.archivedAt = const Value.absent(),
  });
  DancersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.notes = const Value.absent(),
    this.firstMetDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.archivedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Dancer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<DateTime>? firstMetDate,
    Expression<DateTime>? createdAt,
    Expression<bool>? isArchived,
    Expression<DateTime>? archivedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (firstMetDate != null) 'first_met_date': firstMetDate,
      if (createdAt != null) 'created_at': createdAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (archivedAt != null) 'archived_at': archivedAt,
    });
  }

  DancersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? notes,
      Value<DateTime?>? firstMetDate,
      Value<DateTime>? createdAt,
      Value<bool>? isArchived,
      Value<DateTime?>? archivedAt}) {
    return DancersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      firstMetDate: firstMetDate ?? this.firstMetDate,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (firstMetDate.present) {
      map['first_met_date'] = Variable<DateTime>(firstMetDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DancersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('firstMetDate: $firstMetDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }
}

class $RanksTable extends Ranks with TableInfo<$RanksTable, Rank> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RanksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ordinalMeta =
      const VerificationMeta('ordinal');
  @override
  late final GeneratedColumn<int> ordinal = GeneratedColumn<int>(
      'ordinal', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, ordinal, isArchived, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ranks';
  @override
  VerificationContext validateIntegrity(Insertable<Rank> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ordinal')) {
      context.handle(_ordinalMeta,
          ordinal.isAcceptableOrUnknown(data['ordinal']!, _ordinalMeta));
    } else if (isInserting) {
      context.missing(_ordinalMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rank map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rank(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      ordinal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ordinal'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RanksTable createAlias(String alias) {
    return $RanksTable(attachedDatabase, alias);
  }
}

class Rank extends DataClass implements Insertable<Rank> {
  final int id;
  final String name;
  final int ordinal;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Rank(
      {required this.id,
      required this.name,
      required this.ordinal,
      required this.isArchived,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['ordinal'] = Variable<int>(ordinal);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RanksCompanion toCompanion(bool nullToAbsent) {
    return RanksCompanion(
      id: Value(id),
      name: Value(name),
      ordinal: Value(ordinal),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Rank.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rank(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ordinal: serializer.fromJson<int>(json['ordinal']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'ordinal': serializer.toJson<int>(ordinal),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Rank copyWith(
          {int? id,
          String? name,
          int? ordinal,
          bool? isArchived,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Rank(
        id: id ?? this.id,
        name: name ?? this.name,
        ordinal: ordinal ?? this.ordinal,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Rank copyWithCompanion(RanksCompanion data) {
    return Rank(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      ordinal: data.ordinal.present ? data.ordinal.value : this.ordinal,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rank(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ordinal: $ordinal, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, ordinal, isArchived, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rank &&
          other.id == this.id &&
          other.name == this.name &&
          other.ordinal == this.ordinal &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RanksCompanion extends UpdateCompanion<Rank> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> ordinal;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RanksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ordinal = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RanksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int ordinal,
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        ordinal = Value(ordinal);
  static Insertable<Rank> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? ordinal,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ordinal != null) 'ordinal': ordinal,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RanksCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? ordinal,
      Value<bool>? isArchived,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return RanksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ordinal: ordinal ?? this.ordinal,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ordinal.present) {
      map['ordinal'] = Variable<int>(ordinal.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RanksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ordinal: $ordinal, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $RankingsTable extends Rankings with TableInfo<$RankingsTable, Ranking> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RankingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _eventIdMeta =
      const VerificationMeta('eventId');
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
      'event_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES events (id) ON DELETE CASCADE'));
  static const VerificationMeta _dancerIdMeta =
      const VerificationMeta('dancerId');
  @override
  late final GeneratedColumn<int> dancerId = GeneratedColumn<int>(
      'dancer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES dancers (id) ON DELETE CASCADE'));
  static const VerificationMeta _rankIdMeta = const VerificationMeta('rankId');
  @override
  late final GeneratedColumn<int> rankId = GeneratedColumn<int>(
      'rank_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES ranks (id)'));
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, eventId, dancerId, rankId, reason, createdAt, lastUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rankings';
  @override
  VerificationContext validateIntegrity(Insertable<Ranking> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('dancer_id')) {
      context.handle(_dancerIdMeta,
          dancerId.isAcceptableOrUnknown(data['dancer_id']!, _dancerIdMeta));
    } else if (isInserting) {
      context.missing(_dancerIdMeta);
    }
    if (data.containsKey('rank_id')) {
      context.handle(_rankIdMeta,
          rankId.isAcceptableOrUnknown(data['rank_id']!, _rankIdMeta));
    } else if (isInserting) {
      context.missing(_rankIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {eventId, dancerId},
      ];
  @override
  Ranking map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ranking(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      eventId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}event_id'])!,
      dancerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dancer_id'])!,
      rankId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rank_id'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
    );
  }

  @override
  $RankingsTable createAlias(String alias) {
    return $RankingsTable(attachedDatabase, alias);
  }
}

class Ranking extends DataClass implements Insertable<Ranking> {
  final int id;
  final int eventId;
  final int dancerId;
  final int rankId;
  final String? reason;
  final DateTime createdAt;
  final DateTime lastUpdated;
  const Ranking(
      {required this.id,
      required this.eventId,
      required this.dancerId,
      required this.rankId,
      this.reason,
      required this.createdAt,
      required this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<int>(eventId);
    map['dancer_id'] = Variable<int>(dancerId);
    map['rank_id'] = Variable<int>(rankId);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  RankingsCompanion toCompanion(bool nullToAbsent) {
    return RankingsCompanion(
      id: Value(id),
      eventId: Value(eventId),
      dancerId: Value(dancerId),
      rankId: Value(rankId),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      createdAt: Value(createdAt),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory Ranking.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ranking(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<int>(json['eventId']),
      dancerId: serializer.fromJson<int>(json['dancerId']),
      rankId: serializer.fromJson<int>(json['rankId']),
      reason: serializer.fromJson<String?>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<int>(eventId),
      'dancerId': serializer.toJson<int>(dancerId),
      'rankId': serializer.toJson<int>(rankId),
      'reason': serializer.toJson<String?>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  Ranking copyWith(
          {int? id,
          int? eventId,
          int? dancerId,
          int? rankId,
          Value<String?> reason = const Value.absent(),
          DateTime? createdAt,
          DateTime? lastUpdated}) =>
      Ranking(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        dancerId: dancerId ?? this.dancerId,
        rankId: rankId ?? this.rankId,
        reason: reason.present ? reason.value : this.reason,
        createdAt: createdAt ?? this.createdAt,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
  Ranking copyWithCompanion(RankingsCompanion data) {
    return Ranking(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      dancerId: data.dancerId.present ? data.dancerId.value : this.dancerId,
      rankId: data.rankId.present ? data.rankId.value : this.rankId,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ranking(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('dancerId: $dancerId, ')
          ..write('rankId: $rankId, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, eventId, dancerId, rankId, reason, createdAt, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ranking &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.dancerId == this.dancerId &&
          other.rankId == this.rankId &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt &&
          other.lastUpdated == this.lastUpdated);
}

class RankingsCompanion extends UpdateCompanion<Ranking> {
  final Value<int> id;
  final Value<int> eventId;
  final Value<int> dancerId;
  final Value<int> rankId;
  final Value<String?> reason;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastUpdated;
  const RankingsCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.dancerId = const Value.absent(),
    this.rankId = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  RankingsCompanion.insert({
    this.id = const Value.absent(),
    required int eventId,
    required int dancerId,
    required int rankId,
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  })  : eventId = Value(eventId),
        dancerId = Value(dancerId),
        rankId = Value(rankId);
  static Insertable<Ranking> custom({
    Expression<int>? id,
    Expression<int>? eventId,
    Expression<int>? dancerId,
    Expression<int>? rankId,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (dancerId != null) 'dancer_id': dancerId,
      if (rankId != null) 'rank_id': rankId,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  RankingsCompanion copyWith(
      {Value<int>? id,
      Value<int>? eventId,
      Value<int>? dancerId,
      Value<int>? rankId,
      Value<String?>? reason,
      Value<DateTime>? createdAt,
      Value<DateTime>? lastUpdated}) {
    return RankingsCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      dancerId: dancerId ?? this.dancerId,
      rankId: rankId ?? this.rankId,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (dancerId.present) {
      map['dancer_id'] = Variable<int>(dancerId.value);
    }
    if (rankId.present) {
      map['rank_id'] = Variable<int>(rankId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RankingsCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('dancerId: $dancerId, ')
          ..write('rankId: $rankId, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $ScoresTable extends Scores with TableInfo<$ScoresTable, Score> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _ordinalMeta =
      const VerificationMeta('ordinal');
  @override
  late final GeneratedColumn<int> ordinal = GeneratedColumn<int>(
      'ordinal', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, ordinal, isArchived, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scores';
  @override
  VerificationContext validateIntegrity(Insertable<Score> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('ordinal')) {
      context.handle(_ordinalMeta,
          ordinal.isAcceptableOrUnknown(data['ordinal']!, _ordinalMeta));
    } else if (isInserting) {
      context.missing(_ordinalMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Score map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Score(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      ordinal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ordinal'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ScoresTable createAlias(String alias) {
    return $ScoresTable(attachedDatabase, alias);
  }
}

class Score extends DataClass implements Insertable<Score> {
  final int id;
  final String name;
  final int ordinal;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Score(
      {required this.id,
      required this.name,
      required this.ordinal,
      required this.isArchived,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['ordinal'] = Variable<int>(ordinal);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ScoresCompanion toCompanion(bool nullToAbsent) {
    return ScoresCompanion(
      id: Value(id),
      name: Value(name),
      ordinal: Value(ordinal),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Score.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Score(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ordinal: serializer.fromJson<int>(json['ordinal']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'ordinal': serializer.toJson<int>(ordinal),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Score copyWith(
          {int? id,
          String? name,
          int? ordinal,
          bool? isArchived,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Score(
        id: id ?? this.id,
        name: name ?? this.name,
        ordinal: ordinal ?? this.ordinal,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Score copyWithCompanion(ScoresCompanion data) {
    return Score(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      ordinal: data.ordinal.present ? data.ordinal.value : this.ordinal,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Score(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ordinal: $ordinal, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, ordinal, isArchived, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Score &&
          other.id == this.id &&
          other.name == this.name &&
          other.ordinal == this.ordinal &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ScoresCompanion extends UpdateCompanion<Score> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> ordinal;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ScoresCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ordinal = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ScoresCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int ordinal,
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        ordinal = Value(ordinal);
  static Insertable<Score> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? ordinal,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ordinal != null) 'ordinal': ordinal,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ScoresCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? ordinal,
      Value<bool>? isArchived,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ScoresCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ordinal: ordinal ?? this.ordinal,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (ordinal.present) {
      map['ordinal'] = Variable<int>(ordinal.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScoresCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ordinal: $ordinal, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AttendancesTable extends Attendances
    with TableInfo<$AttendancesTable, Attendance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _eventIdMeta =
      const VerificationMeta('eventId');
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
      'event_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES events (id) ON DELETE CASCADE'));
  static const VerificationMeta _dancerIdMeta =
      const VerificationMeta('dancerId');
  @override
  late final GeneratedColumn<int> dancerId = GeneratedColumn<int>(
      'dancer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES dancers (id) ON DELETE CASCADE'));
  static const VerificationMeta _markedAtMeta =
      const VerificationMeta('markedAt');
  @override
  late final GeneratedColumn<DateTime> markedAt = GeneratedColumn<DateTime>(
      'marked_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('present'));
  static const VerificationMeta _dancedAtMeta =
      const VerificationMeta('dancedAt');
  @override
  late final GeneratedColumn<DateTime> dancedAt = GeneratedColumn<DateTime>(
      'danced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _impressionMeta =
      const VerificationMeta('impression');
  @override
  late final GeneratedColumn<String> impression = GeneratedColumn<String>(
      'impression', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scoreIdMeta =
      const VerificationMeta('scoreId');
  @override
  late final GeneratedColumn<int> scoreId = GeneratedColumn<int>(
      'score_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES scores (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, eventId, dancerId, markedAt, status, dancedAt, impression, scoreId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendances';
  @override
  VerificationContext validateIntegrity(Insertable<Attendance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('dancer_id')) {
      context.handle(_dancerIdMeta,
          dancerId.isAcceptableOrUnknown(data['dancer_id']!, _dancerIdMeta));
    } else if (isInserting) {
      context.missing(_dancerIdMeta);
    }
    if (data.containsKey('marked_at')) {
      context.handle(_markedAtMeta,
          markedAt.isAcceptableOrUnknown(data['marked_at']!, _markedAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('danced_at')) {
      context.handle(_dancedAtMeta,
          dancedAt.isAcceptableOrUnknown(data['danced_at']!, _dancedAtMeta));
    }
    if (data.containsKey('impression')) {
      context.handle(
          _impressionMeta,
          impression.isAcceptableOrUnknown(
              data['impression']!, _impressionMeta));
    }
    if (data.containsKey('score_id')) {
      context.handle(_scoreIdMeta,
          scoreId.isAcceptableOrUnknown(data['score_id']!, _scoreIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {eventId, dancerId},
      ];
  @override
  Attendance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attendance(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      eventId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}event_id'])!,
      dancerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dancer_id'])!,
      markedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}marked_at'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      dancedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}danced_at']),
      impression: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}impression']),
      scoreId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score_id']),
    );
  }

  @override
  $AttendancesTable createAlias(String alias) {
    return $AttendancesTable(attachedDatabase, alias);
  }
}

class Attendance extends DataClass implements Insertable<Attendance> {
  final int id;
  final int eventId;
  final int dancerId;
  final DateTime markedAt;
  final String status;
  final DateTime? dancedAt;
  final String? impression;
  final int? scoreId;
  const Attendance(
      {required this.id,
      required this.eventId,
      required this.dancerId,
      required this.markedAt,
      required this.status,
      this.dancedAt,
      this.impression,
      this.scoreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<int>(eventId);
    map['dancer_id'] = Variable<int>(dancerId);
    map['marked_at'] = Variable<DateTime>(markedAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || dancedAt != null) {
      map['danced_at'] = Variable<DateTime>(dancedAt);
    }
    if (!nullToAbsent || impression != null) {
      map['impression'] = Variable<String>(impression);
    }
    if (!nullToAbsent || scoreId != null) {
      map['score_id'] = Variable<int>(scoreId);
    }
    return map;
  }

  AttendancesCompanion toCompanion(bool nullToAbsent) {
    return AttendancesCompanion(
      id: Value(id),
      eventId: Value(eventId),
      dancerId: Value(dancerId),
      markedAt: Value(markedAt),
      status: Value(status),
      dancedAt: dancedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dancedAt),
      impression: impression == null && nullToAbsent
          ? const Value.absent()
          : Value(impression),
      scoreId: scoreId == null && nullToAbsent
          ? const Value.absent()
          : Value(scoreId),
    );
  }

  factory Attendance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attendance(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<int>(json['eventId']),
      dancerId: serializer.fromJson<int>(json['dancerId']),
      markedAt: serializer.fromJson<DateTime>(json['markedAt']),
      status: serializer.fromJson<String>(json['status']),
      dancedAt: serializer.fromJson<DateTime?>(json['dancedAt']),
      impression: serializer.fromJson<String?>(json['impression']),
      scoreId: serializer.fromJson<int?>(json['scoreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<int>(eventId),
      'dancerId': serializer.toJson<int>(dancerId),
      'markedAt': serializer.toJson<DateTime>(markedAt),
      'status': serializer.toJson<String>(status),
      'dancedAt': serializer.toJson<DateTime?>(dancedAt),
      'impression': serializer.toJson<String?>(impression),
      'scoreId': serializer.toJson<int?>(scoreId),
    };
  }

  Attendance copyWith(
          {int? id,
          int? eventId,
          int? dancerId,
          DateTime? markedAt,
          String? status,
          Value<DateTime?> dancedAt = const Value.absent(),
          Value<String?> impression = const Value.absent(),
          Value<int?> scoreId = const Value.absent()}) =>
      Attendance(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        dancerId: dancerId ?? this.dancerId,
        markedAt: markedAt ?? this.markedAt,
        status: status ?? this.status,
        dancedAt: dancedAt.present ? dancedAt.value : this.dancedAt,
        impression: impression.present ? impression.value : this.impression,
        scoreId: scoreId.present ? scoreId.value : this.scoreId,
      );
  Attendance copyWithCompanion(AttendancesCompanion data) {
    return Attendance(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      dancerId: data.dancerId.present ? data.dancerId.value : this.dancerId,
      markedAt: data.markedAt.present ? data.markedAt.value : this.markedAt,
      status: data.status.present ? data.status.value : this.status,
      dancedAt: data.dancedAt.present ? data.dancedAt.value : this.dancedAt,
      impression:
          data.impression.present ? data.impression.value : this.impression,
      scoreId: data.scoreId.present ? data.scoreId.value : this.scoreId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attendance(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('dancerId: $dancerId, ')
          ..write('markedAt: $markedAt, ')
          ..write('status: $status, ')
          ..write('dancedAt: $dancedAt, ')
          ..write('impression: $impression, ')
          ..write('scoreId: $scoreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, eventId, dancerId, markedAt, status, dancedAt, impression, scoreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attendance &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.dancerId == this.dancerId &&
          other.markedAt == this.markedAt &&
          other.status == this.status &&
          other.dancedAt == this.dancedAt &&
          other.impression == this.impression &&
          other.scoreId == this.scoreId);
}

class AttendancesCompanion extends UpdateCompanion<Attendance> {
  final Value<int> id;
  final Value<int> eventId;
  final Value<int> dancerId;
  final Value<DateTime> markedAt;
  final Value<String> status;
  final Value<DateTime?> dancedAt;
  final Value<String?> impression;
  final Value<int?> scoreId;
  const AttendancesCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.dancerId = const Value.absent(),
    this.markedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.dancedAt = const Value.absent(),
    this.impression = const Value.absent(),
    this.scoreId = const Value.absent(),
  });
  AttendancesCompanion.insert({
    this.id = const Value.absent(),
    required int eventId,
    required int dancerId,
    this.markedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.dancedAt = const Value.absent(),
    this.impression = const Value.absent(),
    this.scoreId = const Value.absent(),
  })  : eventId = Value(eventId),
        dancerId = Value(dancerId);
  static Insertable<Attendance> custom({
    Expression<int>? id,
    Expression<int>? eventId,
    Expression<int>? dancerId,
    Expression<DateTime>? markedAt,
    Expression<String>? status,
    Expression<DateTime>? dancedAt,
    Expression<String>? impression,
    Expression<int>? scoreId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (dancerId != null) 'dancer_id': dancerId,
      if (markedAt != null) 'marked_at': markedAt,
      if (status != null) 'status': status,
      if (dancedAt != null) 'danced_at': dancedAt,
      if (impression != null) 'impression': impression,
      if (scoreId != null) 'score_id': scoreId,
    });
  }

  AttendancesCompanion copyWith(
      {Value<int>? id,
      Value<int>? eventId,
      Value<int>? dancerId,
      Value<DateTime>? markedAt,
      Value<String>? status,
      Value<DateTime?>? dancedAt,
      Value<String?>? impression,
      Value<int?>? scoreId}) {
    return AttendancesCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      dancerId: dancerId ?? this.dancerId,
      markedAt: markedAt ?? this.markedAt,
      status: status ?? this.status,
      dancedAt: dancedAt ?? this.dancedAt,
      impression: impression ?? this.impression,
      scoreId: scoreId ?? this.scoreId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (dancerId.present) {
      map['dancer_id'] = Variable<int>(dancerId.value);
    }
    if (markedAt.present) {
      map['marked_at'] = Variable<DateTime>(markedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dancedAt.present) {
      map['danced_at'] = Variable<DateTime>(dancedAt.value);
    }
    if (impression.present) {
      map['impression'] = Variable<String>(impression.value);
    }
    if (scoreId.present) {
      map['score_id'] = Variable<int>(scoreId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendancesCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('dancerId: $dancerId, ')
          ..write('markedAt: $markedAt, ')
          ..write('status: $status, ')
          ..write('dancedAt: $dancedAt, ')
          ..write('impression: $impression, ')
          ..write('scoreId: $scoreId')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  final DateTime createdAt;
  const Tag({required this.id, required this.name, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tag copyWith({int? id, String? name, DateTime? createdAt}) => Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TagsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<DateTime>? createdAt}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DancerTagsTable extends DancerTags
    with TableInfo<$DancerTagsTable, DancerTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DancerTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dancerIdMeta =
      const VerificationMeta('dancerId');
  @override
  late final GeneratedColumn<int> dancerId = GeneratedColumn<int>(
      'dancer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES dancers (id) ON DELETE CASCADE'));
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES tags (id) ON DELETE CASCADE'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [dancerId, tagId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dancer_tags';
  @override
  VerificationContext validateIntegrity(Insertable<DancerTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dancer_id')) {
      context.handle(_dancerIdMeta,
          dancerId.isAcceptableOrUnknown(data['dancer_id']!, _dancerIdMeta));
    } else if (isInserting) {
      context.missing(_dancerIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dancerId, tagId};
  @override
  DancerTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DancerTag(
      dancerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dancer_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tag_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DancerTagsTable createAlias(String alias) {
    return $DancerTagsTable(attachedDatabase, alias);
  }
}

class DancerTag extends DataClass implements Insertable<DancerTag> {
  final int dancerId;
  final int tagId;
  final DateTime createdAt;
  const DancerTag(
      {required this.dancerId, required this.tagId, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dancer_id'] = Variable<int>(dancerId);
    map['tag_id'] = Variable<int>(tagId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DancerTagsCompanion toCompanion(bool nullToAbsent) {
    return DancerTagsCompanion(
      dancerId: Value(dancerId),
      tagId: Value(tagId),
      createdAt: Value(createdAt),
    );
  }

  factory DancerTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DancerTag(
      dancerId: serializer.fromJson<int>(json['dancerId']),
      tagId: serializer.fromJson<int>(json['tagId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dancerId': serializer.toJson<int>(dancerId),
      'tagId': serializer.toJson<int>(tagId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DancerTag copyWith({int? dancerId, int? tagId, DateTime? createdAt}) =>
      DancerTag(
        dancerId: dancerId ?? this.dancerId,
        tagId: tagId ?? this.tagId,
        createdAt: createdAt ?? this.createdAt,
      );
  DancerTag copyWithCompanion(DancerTagsCompanion data) {
    return DancerTag(
      dancerId: data.dancerId.present ? data.dancerId.value : this.dancerId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DancerTag(')
          ..write('dancerId: $dancerId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dancerId, tagId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DancerTag &&
          other.dancerId == this.dancerId &&
          other.tagId == this.tagId &&
          other.createdAt == this.createdAt);
}

class DancerTagsCompanion extends UpdateCompanion<DancerTag> {
  final Value<int> dancerId;
  final Value<int> tagId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const DancerTagsCompanion({
    this.dancerId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DancerTagsCompanion.insert({
    required int dancerId,
    required int tagId,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : dancerId = Value(dancerId),
        tagId = Value(tagId);
  static Insertable<DancerTag> custom({
    Expression<int>? dancerId,
    Expression<int>? tagId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dancerId != null) 'dancer_id': dancerId,
      if (tagId != null) 'tag_id': tagId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DancerTagsCompanion copyWith(
      {Value<int>? dancerId,
      Value<int>? tagId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return DancerTagsCompanion(
      dancerId: dancerId ?? this.dancerId,
      tagId: tagId ?? this.tagId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dancerId.present) {
      map['dancer_id'] = Variable<int>(dancerId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DancerTagsCompanion(')
          ..write('dancerId: $dancerId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventsTable events = $EventsTable(this);
  late final $DancersTable dancers = $DancersTable(this);
  late final $RanksTable ranks = $RanksTable(this);
  late final $RankingsTable rankings = $RankingsTable(this);
  late final $ScoresTable scores = $ScoresTable(this);
  late final $AttendancesTable attendances = $AttendancesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $DancerTagsTable dancerTags = $DancerTagsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [events, dancers, ranks, rankings, scores, attendances, tags, dancerTags];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('events',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('rankings', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('dancers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('rankings', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('events',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('attendances', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('dancers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('attendances', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('dancers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('dancer_tags', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('tags',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('dancer_tags', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  required String name,
  required DateTime date,
  Value<DateTime> createdAt,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> date,
  Value<DateTime> createdAt,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RankingsTable, List<Ranking>> _rankingsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.rankings,
          aliasName: $_aliasNameGenerator(db.events.id, db.rankings.eventId));

  $$RankingsTableProcessedTableManager get rankingsRefs {
    final manager = $$RankingsTableTableManager($_db, $_db.rankings)
        .filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rankingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AttendancesTable, List<Attendance>>
      _attendancesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.attendances,
              aliasName:
                  $_aliasNameGenerator(db.events.id, db.attendances.eventId));

  $$AttendancesTableProcessedTableManager get attendancesRefs {
    final manager = $$AttendancesTableTableManager($_db, $_db.attendances)
        .filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> rankingsRefs(
      Expression<bool> Function($$RankingsTableFilterComposer f) f) {
    final $$RankingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rankings,
        getReferencedColumn: (t) => t.eventId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RankingsTableFilterComposer(
              $db: $db,
              $table: $db.rankings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> attendancesRefs(
      Expression<bool> Function($$AttendancesTableFilterComposer f) f) {
    final $$AttendancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendances,
        getReferencedColumn: (t) => t.eventId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendancesTableFilterComposer(
              $db: $db,
              $table: $db.attendances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> rankingsRefs<T extends Object>(
      Expression<T> Function($$RankingsTableAnnotationComposer a) f) {
    final $$RankingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rankings,
        getReferencedColumn: (t) => t.eventId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RankingsTableAnnotationComposer(
              $db: $db,
              $table: $db.rankings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> attendancesRefs<T extends Object>(
      Expression<T> Function($$AttendancesTableAnnotationComposer a) f) {
    final $$AttendancesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendances,
        getReferencedColumn: (t) => t.eventId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendancesTableAnnotationComposer(
              $db: $db,
              $table: $db.attendances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function({bool rankingsRefs, bool attendancesRefs})> {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              EventsCompanion(
            id: id,
            name: name,
            date: date,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required DateTime date,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              EventsCompanion.insert(
            id: id,
            name: name,
            date: date,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$EventsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {rankingsRefs = false, attendancesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (rankingsRefs) db.rankings,
                if (attendancesRefs) db.attendances
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (rankingsRefs)
                    await $_getPrefetchedData<Event, $EventsTable, Ranking>(
                        currentTable: table,
                        referencedTable:
                            $$EventsTableReferences._rankingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventsTableReferences(db, table, p0).rankingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.eventId == item.id),
                        typedResults: items),
                  if (attendancesRefs)
                    await $_getPrefetchedData<Event, $EventsTable, Attendance>(
                        currentTable: table,
                        referencedTable:
                            $$EventsTableReferences._attendancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EventsTableReferences(db, table, p0)
                                .attendancesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.eventId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function({bool rankingsRefs, bool attendancesRefs})>;
typedef $$DancersTableCreateCompanionBuilder = DancersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> notes,
  Value<DateTime?> firstMetDate,
  Value<DateTime> createdAt,
  Value<bool> isArchived,
  Value<DateTime?> archivedAt,
});
typedef $$DancersTableUpdateCompanionBuilder = DancersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> notes,
  Value<DateTime?> firstMetDate,
  Value<DateTime> createdAt,
  Value<bool> isArchived,
  Value<DateTime?> archivedAt,
});

final class $$DancersTableReferences
    extends BaseReferences<_$AppDatabase, $DancersTable, Dancer> {
  $$DancersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RankingsTable, List<Ranking>> _rankingsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.rankings,
          aliasName: $_aliasNameGenerator(db.dancers.id, db.rankings.dancerId));

  $$RankingsTableProcessedTableManager get rankingsRefs {
    final manager = $$RankingsTableTableManager($_db, $_db.rankings)
        .filter((f) => f.dancerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rankingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AttendancesTable, List<Attendance>>
      _attendancesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.attendances,
              aliasName:
                  $_aliasNameGenerator(db.dancers.id, db.attendances.dancerId));

  $$AttendancesTableProcessedTableManager get attendancesRefs {
    final manager = $$AttendancesTableTableManager($_db, $_db.attendances)
        .filter((f) => f.dancerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DancerTagsTable, List<DancerTag>>
      _dancerTagsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.dancerTags,
              aliasName:
                  $_aliasNameGenerator(db.dancers.id, db.dancerTags.dancerId));

  $$DancerTagsTableProcessedTableManager get dancerTagsRefs {
    final manager = $$DancerTagsTableTableManager($_db, $_db.dancerTags)
        .filter((f) => f.dancerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dancerTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DancersTableFilterComposer
    extends Composer<_$AppDatabase, $DancersTable> {
  $$DancersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get firstMetDate => $composableBuilder(
      column: $table.firstMetDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> rankingsRefs(
      Expression<bool> Function($$RankingsTableFilterComposer f) f) {
    final $$RankingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rankings,
        getReferencedColumn: (t) => t.dancerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RankingsTableFilterComposer(
              $db: $db,
              $table: $db.rankings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> attendancesRefs(
      Expression<bool> Function($$AttendancesTableFilterComposer f) f) {
    final $$AttendancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendances,
        getReferencedColumn: (t) => t.dancerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendancesTableFilterComposer(
              $db: $db,
              $table: $db.attendances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> dancerTagsRefs(
      Expression<bool> Function($$DancerTagsTableFilterComposer f) f) {
    final $$DancerTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dancerTags,
        getReferencedColumn: (t) => t.dancerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancerTagsTableFilterComposer(
              $db: $db,
              $table: $db.dancerTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DancersTableOrderingComposer
    extends Composer<_$AppDatabase, $DancersTable> {
  $$DancersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get firstMetDate => $composableBuilder(
      column: $table.firstMetDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnOrderings(column));
}

class $$DancersTableAnnotationComposer
    extends Composer<_$AppDatabase, $DancersTable> {
  $$DancersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get firstMetDate => $composableBuilder(
      column: $table.firstMetDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => column);

  Expression<T> rankingsRefs<T extends Object>(
      Expression<T> Function($$RankingsTableAnnotationComposer a) f) {
    final $$RankingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rankings,
        getReferencedColumn: (t) => t.dancerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RankingsTableAnnotationComposer(
              $db: $db,
              $table: $db.rankings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> attendancesRefs<T extends Object>(
      Expression<T> Function($$AttendancesTableAnnotationComposer a) f) {
    final $$AttendancesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendances,
        getReferencedColumn: (t) => t.dancerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendancesTableAnnotationComposer(
              $db: $db,
              $table: $db.attendances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> dancerTagsRefs<T extends Object>(
      Expression<T> Function($$DancerTagsTableAnnotationComposer a) f) {
    final $$DancerTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dancerTags,
        getReferencedColumn: (t) => t.dancerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancerTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.dancerTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DancersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DancersTable,
    Dancer,
    $$DancersTableFilterComposer,
    $$DancersTableOrderingComposer,
    $$DancersTableAnnotationComposer,
    $$DancersTableCreateCompanionBuilder,
    $$DancersTableUpdateCompanionBuilder,
    (Dancer, $$DancersTableReferences),
    Dancer,
    PrefetchHooks Function(
        {bool rankingsRefs, bool attendancesRefs, bool dancerTagsRefs})> {
  $$DancersTableTableManager(_$AppDatabase db, $DancersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DancersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DancersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DancersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> firstMetDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime?> archivedAt = const Value.absent(),
          }) =>
              DancersCompanion(
            id: id,
            name: name,
            notes: notes,
            firstMetDate: firstMetDate,
            createdAt: createdAt,
            isArchived: isArchived,
            archivedAt: archivedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> notes = const Value.absent(),
            Value<DateTime?> firstMetDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime?> archivedAt = const Value.absent(),
          }) =>
              DancersCompanion.insert(
            id: id,
            name: name,
            notes: notes,
            firstMetDate: firstMetDate,
            createdAt: createdAt,
            isArchived: isArchived,
            archivedAt: archivedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DancersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {rankingsRefs = false,
              attendancesRefs = false,
              dancerTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (rankingsRefs) db.rankings,
                if (attendancesRefs) db.attendances,
                if (dancerTagsRefs) db.dancerTags
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (rankingsRefs)
                    await $_getPrefetchedData<Dancer, $DancersTable, Ranking>(
                        currentTable: table,
                        referencedTable:
                            $$DancersTableReferences._rankingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DancersTableReferences(db, table, p0)
                                .rankingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.dancerId == item.id),
                        typedResults: items),
                  if (attendancesRefs)
                    await $_getPrefetchedData<Dancer, $DancersTable,
                            Attendance>(
                        currentTable: table,
                        referencedTable:
                            $$DancersTableReferences._attendancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DancersTableReferences(db, table, p0)
                                .attendancesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.dancerId == item.id),
                        typedResults: items),
                  if (dancerTagsRefs)
                    await $_getPrefetchedData<Dancer, $DancersTable, DancerTag>(
                        currentTable: table,
                        referencedTable:
                            $$DancersTableReferences._dancerTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DancersTableReferences(db, table, p0)
                                .dancerTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.dancerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DancersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DancersTable,
    Dancer,
    $$DancersTableFilterComposer,
    $$DancersTableOrderingComposer,
    $$DancersTableAnnotationComposer,
    $$DancersTableCreateCompanionBuilder,
    $$DancersTableUpdateCompanionBuilder,
    (Dancer, $$DancersTableReferences),
    Dancer,
    PrefetchHooks Function(
        {bool rankingsRefs, bool attendancesRefs, bool dancerTagsRefs})>;
typedef $$RanksTableCreateCompanionBuilder = RanksCompanion Function({
  Value<int> id,
  required String name,
  required int ordinal,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$RanksTableUpdateCompanionBuilder = RanksCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> ordinal,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$RanksTableReferences
    extends BaseReferences<_$AppDatabase, $RanksTable, Rank> {
  $$RanksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RankingsTable, List<Ranking>> _rankingsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.rankings,
          aliasName: $_aliasNameGenerator(db.ranks.id, db.rankings.rankId));

  $$RankingsTableProcessedTableManager get rankingsRefs {
    final manager = $$RankingsTableTableManager($_db, $_db.rankings)
        .filter((f) => f.rankId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rankingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RanksTableFilterComposer extends Composer<_$AppDatabase, $RanksTable> {
  $$RanksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ordinal => $composableBuilder(
      column: $table.ordinal, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> rankingsRefs(
      Expression<bool> Function($$RankingsTableFilterComposer f) f) {
    final $$RankingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rankings,
        getReferencedColumn: (t) => t.rankId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RankingsTableFilterComposer(
              $db: $db,
              $table: $db.rankings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RanksTableOrderingComposer
    extends Composer<_$AppDatabase, $RanksTable> {
  $$RanksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ordinal => $composableBuilder(
      column: $table.ordinal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RanksTableAnnotationComposer
    extends Composer<_$AppDatabase, $RanksTable> {
  $$RanksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get ordinal =>
      $composableBuilder(column: $table.ordinal, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> rankingsRefs<T extends Object>(
      Expression<T> Function($$RankingsTableAnnotationComposer a) f) {
    final $$RankingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.rankings,
        getReferencedColumn: (t) => t.rankId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RankingsTableAnnotationComposer(
              $db: $db,
              $table: $db.rankings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RanksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RanksTable,
    Rank,
    $$RanksTableFilterComposer,
    $$RanksTableOrderingComposer,
    $$RanksTableAnnotationComposer,
    $$RanksTableCreateCompanionBuilder,
    $$RanksTableUpdateCompanionBuilder,
    (Rank, $$RanksTableReferences),
    Rank,
    PrefetchHooks Function({bool rankingsRefs})> {
  $$RanksTableTableManager(_$AppDatabase db, $RanksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RanksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RanksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RanksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> ordinal = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              RanksCompanion(
            id: id,
            name: name,
            ordinal: ordinal,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int ordinal,
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              RanksCompanion.insert(
            id: id,
            name: name,
            ordinal: ordinal,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RanksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({rankingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (rankingsRefs) db.rankings],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (rankingsRefs)
                    await $_getPrefetchedData<Rank, $RanksTable, Ranking>(
                        currentTable: table,
                        referencedTable:
                            $$RanksTableReferences._rankingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RanksTableReferences(db, table, p0).rankingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.rankId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RanksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RanksTable,
    Rank,
    $$RanksTableFilterComposer,
    $$RanksTableOrderingComposer,
    $$RanksTableAnnotationComposer,
    $$RanksTableCreateCompanionBuilder,
    $$RanksTableUpdateCompanionBuilder,
    (Rank, $$RanksTableReferences),
    Rank,
    PrefetchHooks Function({bool rankingsRefs})>;
typedef $$RankingsTableCreateCompanionBuilder = RankingsCompanion Function({
  Value<int> id,
  required int eventId,
  required int dancerId,
  required int rankId,
  Value<String?> reason,
  Value<DateTime> createdAt,
  Value<DateTime> lastUpdated,
});
typedef $$RankingsTableUpdateCompanionBuilder = RankingsCompanion Function({
  Value<int> id,
  Value<int> eventId,
  Value<int> dancerId,
  Value<int> rankId,
  Value<String?> reason,
  Value<DateTime> createdAt,
  Value<DateTime> lastUpdated,
});

final class $$RankingsTableReferences
    extends BaseReferences<_$AppDatabase, $RankingsTable, Ranking> {
  $$RankingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) => db.events
      .createAlias($_aliasNameGenerator(db.rankings.eventId, db.events.id));

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DancersTable _dancerIdTable(_$AppDatabase db) => db.dancers
      .createAlias($_aliasNameGenerator(db.rankings.dancerId, db.dancers.id));

  $$DancersTableProcessedTableManager get dancerId {
    final $_column = $_itemColumn<int>('dancer_id')!;

    final manager = $$DancersTableTableManager($_db, $_db.dancers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dancerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RanksTable _rankIdTable(_$AppDatabase db) => db.ranks
      .createAlias($_aliasNameGenerator(db.rankings.rankId, db.ranks.id));

  $$RanksTableProcessedTableManager get rankId {
    final $_column = $_itemColumn<int>('rank_id')!;

    final manager = $$RanksTableTableManager($_db, $_db.ranks)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RankingsTableFilterComposer
    extends Composer<_$AppDatabase, $RankingsTable> {
  $$RankingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DancersTableFilterComposer get dancerId {
    final $$DancersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dancerId,
        referencedTable: $db.dancers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancersTableFilterComposer(
              $db: $db,
              $table: $db.dancers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RanksTableFilterComposer get rankId {
    final $$RanksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rankId,
        referencedTable: $db.ranks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RanksTableFilterComposer(
              $db: $db,
              $table: $db.ranks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RankingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RankingsTable> {
  $$RankingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableOrderingComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DancersTableOrderingComposer get dancerId {
    final $$DancersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dancerId,
        referencedTable: $db.dancers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancersTableOrderingComposer(
              $db: $db,
              $table: $db.dancers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RanksTableOrderingComposer get rankId {
    final $$RanksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rankId,
        referencedTable: $db.ranks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RanksTableOrderingComposer(
              $db: $db,
              $table: $db.ranks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RankingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RankingsTable> {
  $$RankingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DancersTableAnnotationComposer get dancerId {
    final $$DancersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dancerId,
        referencedTable: $db.dancers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancersTableAnnotationComposer(
              $db: $db,
              $table: $db.dancers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RanksTableAnnotationComposer get rankId {
    final $$RanksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.rankId,
        referencedTable: $db.ranks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RanksTableAnnotationComposer(
              $db: $db,
              $table: $db.ranks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RankingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RankingsTable,
    Ranking,
    $$RankingsTableFilterComposer,
    $$RankingsTableOrderingComposer,
    $$RankingsTableAnnotationComposer,
    $$RankingsTableCreateCompanionBuilder,
    $$RankingsTableUpdateCompanionBuilder,
    (Ranking, $$RankingsTableReferences),
    Ranking,
    PrefetchHooks Function({bool eventId, bool dancerId, bool rankId})> {
  $$RankingsTableTableManager(_$AppDatabase db, $RankingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RankingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RankingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RankingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> eventId = const Value.absent(),
            Value<int> dancerId = const Value.absent(),
            Value<int> rankId = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
          }) =>
              RankingsCompanion(
            id: id,
            eventId: eventId,
            dancerId: dancerId,
            rankId: rankId,
            reason: reason,
            createdAt: createdAt,
            lastUpdated: lastUpdated,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int eventId,
            required int dancerId,
            required int rankId,
            Value<String?> reason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> lastUpdated = const Value.absent(),
          }) =>
              RankingsCompanion.insert(
            id: id,
            eventId: eventId,
            dancerId: dancerId,
            rankId: rankId,
            reason: reason,
            createdAt: createdAt,
            lastUpdated: lastUpdated,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RankingsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {eventId = false, dancerId = false, rankId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (eventId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.eventId,
                    referencedTable:
                        $$RankingsTableReferences._eventIdTable(db),
                    referencedColumn:
                        $$RankingsTableReferences._eventIdTable(db).id,
                  ) as T;
                }
                if (dancerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dancerId,
                    referencedTable:
                        $$RankingsTableReferences._dancerIdTable(db),
                    referencedColumn:
                        $$RankingsTableReferences._dancerIdTable(db).id,
                  ) as T;
                }
                if (rankId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.rankId,
                    referencedTable: $$RankingsTableReferences._rankIdTable(db),
                    referencedColumn:
                        $$RankingsTableReferences._rankIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RankingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RankingsTable,
    Ranking,
    $$RankingsTableFilterComposer,
    $$RankingsTableOrderingComposer,
    $$RankingsTableAnnotationComposer,
    $$RankingsTableCreateCompanionBuilder,
    $$RankingsTableUpdateCompanionBuilder,
    (Ranking, $$RankingsTableReferences),
    Ranking,
    PrefetchHooks Function({bool eventId, bool dancerId, bool rankId})>;
typedef $$ScoresTableCreateCompanionBuilder = ScoresCompanion Function({
  Value<int> id,
  required String name,
  required int ordinal,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ScoresTableUpdateCompanionBuilder = ScoresCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> ordinal,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ScoresTableReferences
    extends BaseReferences<_$AppDatabase, $ScoresTable, Score> {
  $$ScoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttendancesTable, List<Attendance>>
      _attendancesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.attendances,
              aliasName:
                  $_aliasNameGenerator(db.scores.id, db.attendances.scoreId));

  $$AttendancesTableProcessedTableManager get attendancesRefs {
    final manager = $$AttendancesTableTableManager($_db, $_db.attendances)
        .filter((f) => f.scoreId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendancesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ScoresTableFilterComposer
    extends Composer<_$AppDatabase, $ScoresTable> {
  $$ScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ordinal => $composableBuilder(
      column: $table.ordinal, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> attendancesRefs(
      Expression<bool> Function($$AttendancesTableFilterComposer f) f) {
    final $$AttendancesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendances,
        getReferencedColumn: (t) => t.scoreId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendancesTableFilterComposer(
              $db: $db,
              $table: $db.attendances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $ScoresTable> {
  $$ScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ordinal => $composableBuilder(
      column: $table.ordinal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScoresTable> {
  $$ScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get ordinal =>
      $composableBuilder(column: $table.ordinal, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> attendancesRefs<T extends Object>(
      Expression<T> Function($$AttendancesTableAnnotationComposer a) f) {
    final $$AttendancesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.attendances,
        getReferencedColumn: (t) => t.scoreId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AttendancesTableAnnotationComposer(
              $db: $db,
              $table: $db.attendances,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ScoresTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScoresTable,
    Score,
    $$ScoresTableFilterComposer,
    $$ScoresTableOrderingComposer,
    $$ScoresTableAnnotationComposer,
    $$ScoresTableCreateCompanionBuilder,
    $$ScoresTableUpdateCompanionBuilder,
    (Score, $$ScoresTableReferences),
    Score,
    PrefetchHooks Function({bool attendancesRefs})> {
  $$ScoresTableTableManager(_$AppDatabase db, $ScoresTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> ordinal = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ScoresCompanion(
            id: id,
            name: name,
            ordinal: ordinal,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int ordinal,
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ScoresCompanion.insert(
            id: id,
            name: name,
            ordinal: ordinal,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ScoresTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({attendancesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (attendancesRefs) db.attendances],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attendancesRefs)
                    await $_getPrefetchedData<Score, $ScoresTable, Attendance>(
                        currentTable: table,
                        referencedTable:
                            $$ScoresTableReferences._attendancesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ScoresTableReferences(db, table, p0)
                                .attendancesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.scoreId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ScoresTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScoresTable,
    Score,
    $$ScoresTableFilterComposer,
    $$ScoresTableOrderingComposer,
    $$ScoresTableAnnotationComposer,
    $$ScoresTableCreateCompanionBuilder,
    $$ScoresTableUpdateCompanionBuilder,
    (Score, $$ScoresTableReferences),
    Score,
    PrefetchHooks Function({bool attendancesRefs})>;
typedef $$AttendancesTableCreateCompanionBuilder = AttendancesCompanion
    Function({
  Value<int> id,
  required int eventId,
  required int dancerId,
  Value<DateTime> markedAt,
  Value<String> status,
  Value<DateTime?> dancedAt,
  Value<String?> impression,
  Value<int?> scoreId,
});
typedef $$AttendancesTableUpdateCompanionBuilder = AttendancesCompanion
    Function({
  Value<int> id,
  Value<int> eventId,
  Value<int> dancerId,
  Value<DateTime> markedAt,
  Value<String> status,
  Value<DateTime?> dancedAt,
  Value<String?> impression,
  Value<int?> scoreId,
});

final class $$AttendancesTableReferences
    extends BaseReferences<_$AppDatabase, $AttendancesTable, Attendance> {
  $$AttendancesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$AppDatabase db) => db.events
      .createAlias($_aliasNameGenerator(db.attendances.eventId, db.events.id));

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $DancersTable _dancerIdTable(_$AppDatabase db) =>
      db.dancers.createAlias(
          $_aliasNameGenerator(db.attendances.dancerId, db.dancers.id));

  $$DancersTableProcessedTableManager get dancerId {
    final $_column = $_itemColumn<int>('dancer_id')!;

    final manager = $$DancersTableTableManager($_db, $_db.dancers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dancerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ScoresTable _scoreIdTable(_$AppDatabase db) => db.scores
      .createAlias($_aliasNameGenerator(db.attendances.scoreId, db.scores.id));

  $$ScoresTableProcessedTableManager? get scoreId {
    final $_column = $_itemColumn<int>('score_id');
    if ($_column == null) return null;
    final manager = $$ScoresTableTableManager($_db, $_db.scores)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_scoreIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AttendancesTableFilterComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get markedAt => $composableBuilder(
      column: $table.markedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dancedAt => $composableBuilder(
      column: $table.dancedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get impression => $composableBuilder(
      column: $table.impression, builder: (column) => ColumnFilters(column));

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DancersTableFilterComposer get dancerId {
    final $$DancersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dancerId,
        referencedTable: $db.dancers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancersTableFilterComposer(
              $db: $db,
              $table: $db.dancers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ScoresTableFilterComposer get scoreId {
    final $$ScoresTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scoreId,
        referencedTable: $db.scores,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ScoresTableFilterComposer(
              $db: $db,
              $table: $db.scores,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendancesTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get markedAt => $composableBuilder(
      column: $table.markedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dancedAt => $composableBuilder(
      column: $table.dancedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get impression => $composableBuilder(
      column: $table.impression, builder: (column) => ColumnOrderings(column));

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableOrderingComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DancersTableOrderingComposer get dancerId {
    final $$DancersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dancerId,
        referencedTable: $db.dancers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancersTableOrderingComposer(
              $db: $db,
              $table: $db.dancers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ScoresTableOrderingComposer get scoreId {
    final $$ScoresTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scoreId,
        referencedTable: $db.scores,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ScoresTableOrderingComposer(
              $db: $db,
              $table: $db.scores,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get markedAt =>
      $composableBuilder(column: $table.markedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get dancedAt =>
      $composableBuilder(column: $table.dancedAt, builder: (column) => column);

  GeneratedColumn<String> get impression => $composableBuilder(
      column: $table.impression, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.eventId,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$DancersTableAnnotationComposer get dancerId {
    final $$DancersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dancerId,
        referencedTable: $db.dancers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancersTableAnnotationComposer(
              $db: $db,
              $table: $db.dancers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ScoresTableAnnotationComposer get scoreId {
    final $$ScoresTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.scoreId,
        referencedTable: $db.scores,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ScoresTableAnnotationComposer(
              $db: $db,
              $table: $db.scores,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AttendancesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttendancesTable,
    Attendance,
    $$AttendancesTableFilterComposer,
    $$AttendancesTableOrderingComposer,
    $$AttendancesTableAnnotationComposer,
    $$AttendancesTableCreateCompanionBuilder,
    $$AttendancesTableUpdateCompanionBuilder,
    (Attendance, $$AttendancesTableReferences),
    Attendance,
    PrefetchHooks Function({bool eventId, bool dancerId, bool scoreId})> {
  $$AttendancesTableTableManager(_$AppDatabase db, $AttendancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> eventId = const Value.absent(),
            Value<int> dancerId = const Value.absent(),
            Value<DateTime> markedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> dancedAt = const Value.absent(),
            Value<String?> impression = const Value.absent(),
            Value<int?> scoreId = const Value.absent(),
          }) =>
              AttendancesCompanion(
            id: id,
            eventId: eventId,
            dancerId: dancerId,
            markedAt: markedAt,
            status: status,
            dancedAt: dancedAt,
            impression: impression,
            scoreId: scoreId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int eventId,
            required int dancerId,
            Value<DateTime> markedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> dancedAt = const Value.absent(),
            Value<String?> impression = const Value.absent(),
            Value<int?> scoreId = const Value.absent(),
          }) =>
              AttendancesCompanion.insert(
            id: id,
            eventId: eventId,
            dancerId: dancerId,
            markedAt: markedAt,
            status: status,
            dancedAt: dancedAt,
            impression: impression,
            scoreId: scoreId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AttendancesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {eventId = false, dancerId = false, scoreId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (eventId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.eventId,
                    referencedTable:
                        $$AttendancesTableReferences._eventIdTable(db),
                    referencedColumn:
                        $$AttendancesTableReferences._eventIdTable(db).id,
                  ) as T;
                }
                if (dancerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dancerId,
                    referencedTable:
                        $$AttendancesTableReferences._dancerIdTable(db),
                    referencedColumn:
                        $$AttendancesTableReferences._dancerIdTable(db).id,
                  ) as T;
                }
                if (scoreId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.scoreId,
                    referencedTable:
                        $$AttendancesTableReferences._scoreIdTable(db),
                    referencedColumn:
                        $$AttendancesTableReferences._scoreIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AttendancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttendancesTable,
    Attendance,
    $$AttendancesTableFilterComposer,
    $$AttendancesTableOrderingComposer,
    $$AttendancesTableAnnotationComposer,
    $$AttendancesTableCreateCompanionBuilder,
    $$AttendancesTableUpdateCompanionBuilder,
    (Attendance, $$AttendancesTableReferences),
    Attendance,
    PrefetchHooks Function({bool eventId, bool dancerId, bool scoreId})>;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String name,
  Value<DateTime> createdAt,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<DateTime> createdAt,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DancerTagsTable, List<DancerTag>>
      _dancerTagsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.dancerTags,
              aliasName: $_aliasNameGenerator(db.tags.id, db.dancerTags.tagId));

  $$DancerTagsTableProcessedTableManager get dancerTagsRefs {
    final manager = $$DancerTagsTableTableManager($_db, $_db.dancerTags)
        .filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dancerTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> dancerTagsRefs(
      Expression<bool> Function($$DancerTagsTableFilterComposer f) f) {
    final $$DancerTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dancerTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancerTagsTableFilterComposer(
              $db: $db,
              $table: $db.dancerTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> dancerTagsRefs<T extends Object>(
      Expression<T> Function($$DancerTagsTableAnnotationComposer a) f) {
    final $$DancerTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.dancerTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancerTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.dancerTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, $$TagsTableReferences),
    Tag,
    PrefetchHooks Function({bool dancerTagsRefs})> {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TagsCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TagsCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TagsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({dancerTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (dancerTagsRefs) db.dancerTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dancerTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, DancerTag>(
                        currentTable: table,
                        referencedTable:
                            $$TagsTableReferences._dancerTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TagsTableReferences(db, table, p0).dancerTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tagId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, $$TagsTableReferences),
    Tag,
    PrefetchHooks Function({bool dancerTagsRefs})>;
typedef $$DancerTagsTableCreateCompanionBuilder = DancerTagsCompanion Function({
  required int dancerId,
  required int tagId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$DancerTagsTableUpdateCompanionBuilder = DancerTagsCompanion Function({
  Value<int> dancerId,
  Value<int> tagId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$DancerTagsTableReferences
    extends BaseReferences<_$AppDatabase, $DancerTagsTable, DancerTag> {
  $$DancerTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DancersTable _dancerIdTable(_$AppDatabase db) => db.dancers
      .createAlias($_aliasNameGenerator(db.dancerTags.dancerId, db.dancers.id));

  $$DancersTableProcessedTableManager get dancerId {
    final $_column = $_itemColumn<int>('dancer_id')!;

    final manager = $$DancersTableTableManager($_db, $_db.dancers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dancerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) => db.tags
      .createAlias($_aliasNameGenerator(db.dancerTags.tagId, db.tags.id));

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager($_db, $_db.tags)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DancerTagsTableFilterComposer
    extends Composer<_$AppDatabase, $DancerTagsTable> {
  $$DancerTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$DancersTableFilterComposer get dancerId {
    final $$DancersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dancerId,
        referencedTable: $db.dancers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancersTableFilterComposer(
              $db: $db,
              $table: $db.dancers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableFilterComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DancerTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $DancerTagsTable> {
  $$DancerTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$DancersTableOrderingComposer get dancerId {
    final $$DancersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dancerId,
        referencedTable: $db.dancers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancersTableOrderingComposer(
              $db: $db,
              $table: $db.dancers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableOrderingComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DancerTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DancerTagsTable> {
  $$DancerTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DancersTableAnnotationComposer get dancerId {
    final $$DancersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dancerId,
        referencedTable: $db.dancers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DancersTableAnnotationComposer(
              $db: $db,
              $table: $db.dancers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableAnnotationComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DancerTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DancerTagsTable,
    DancerTag,
    $$DancerTagsTableFilterComposer,
    $$DancerTagsTableOrderingComposer,
    $$DancerTagsTableAnnotationComposer,
    $$DancerTagsTableCreateCompanionBuilder,
    $$DancerTagsTableUpdateCompanionBuilder,
    (DancerTag, $$DancerTagsTableReferences),
    DancerTag,
    PrefetchHooks Function({bool dancerId, bool tagId})> {
  $$DancerTagsTableTableManager(_$AppDatabase db, $DancerTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DancerTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DancerTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DancerTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> dancerId = const Value.absent(),
            Value<int> tagId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DancerTagsCompanion(
            dancerId: dancerId,
            tagId: tagId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int dancerId,
            required int tagId,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DancerTagsCompanion.insert(
            dancerId: dancerId,
            tagId: tagId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DancerTagsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({dancerId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (dancerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dancerId,
                    referencedTable:
                        $$DancerTagsTableReferences._dancerIdTable(db),
                    referencedColumn:
                        $$DancerTagsTableReferences._dancerIdTable(db).id,
                  ) as T;
                }
                if (tagId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tagId,
                    referencedTable:
                        $$DancerTagsTableReferences._tagIdTable(db),
                    referencedColumn:
                        $$DancerTagsTableReferences._tagIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DancerTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DancerTagsTable,
    DancerTag,
    $$DancerTagsTableFilterComposer,
    $$DancerTagsTableOrderingComposer,
    $$DancerTagsTableAnnotationComposer,
    $$DancerTagsTableCreateCompanionBuilder,
    $$DancerTagsTableUpdateCompanionBuilder,
    (DancerTag, $$DancerTagsTableReferences),
    DancerTag,
    PrefetchHooks Function({bool dancerId, bool tagId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$DancersTableTableManager get dancers =>
      $$DancersTableTableManager(_db, _db.dancers);
  $$RanksTableTableManager get ranks =>
      $$RanksTableTableManager(_db, _db.ranks);
  $$RankingsTableTableManager get rankings =>
      $$RankingsTableTableManager(_db, _db.rankings);
  $$ScoresTableTableManager get scores =>
      $$ScoresTableTableManager(_db, _db.scores);
  $$AttendancesTableTableManager get attendances =>
      $$AttendancesTableTableManager(_db, _db.attendances);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$DancerTagsTableTableManager get dancerTags =>
      $$DancerTagsTableTableManager(_db, _db.dancerTags);
}
