// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'recently_played_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RecentlyPlayedEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() recently,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? recently,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? recently,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Recently value) recently,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Recently value)? recently,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Recently value)? recently,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentlyPlayedEventCopyWith<$Res> {
  factory $RecentlyPlayedEventCopyWith(
          RecentlyPlayedEvent value, $Res Function(RecentlyPlayedEvent) then) =
      _$RecentlyPlayedEventCopyWithImpl<$Res, RecentlyPlayedEvent>;
}

/// @nodoc
class _$RecentlyPlayedEventCopyWithImpl<$Res, $Val extends RecentlyPlayedEvent>
    implements $RecentlyPlayedEventCopyWith<$Res> {
  _$RecentlyPlayedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$RecentlyCopyWith<$Res> {
  factory _$$RecentlyCopyWith(
          _$Recently value, $Res Function(_$Recently) then) =
      __$$RecentlyCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RecentlyCopyWithImpl<$Res>
    extends _$RecentlyPlayedEventCopyWithImpl<$Res, _$Recently>
    implements _$$RecentlyCopyWith<$Res> {
  __$$RecentlyCopyWithImpl(_$Recently _value, $Res Function(_$Recently) _then)
      : super(_value, _then);
}

/// @nodoc

class _$Recently implements Recently {
  const _$Recently();

  @override
  String toString() {
    return 'RecentlyPlayedEvent.recently()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Recently);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() recently,
  }) {
    return recently();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? recently,
  }) {
    return recently?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? recently,
    required TResult orElse(),
  }) {
    if (recently != null) {
      return recently();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Recently value) recently,
  }) {
    return recently(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Recently value)? recently,
  }) {
    return recently?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Recently value)? recently,
    required TResult orElse(),
  }) {
    if (recently != null) {
      return recently(this);
    }
    return orElse();
  }
}

abstract class Recently implements RecentlyPlayedEvent {
  const factory Recently() = _$Recently;
}

/// @nodoc
mixin _$RecentlyPlayedState {
  List<RecentSongs> get recentsdb => throw _privateConstructorUsedError;
  List<Songs> get dbSongs => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecentlyPlayedStateCopyWith<RecentlyPlayedState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentlyPlayedStateCopyWith<$Res> {
  factory $RecentlyPlayedStateCopyWith(
          RecentlyPlayedState value, $Res Function(RecentlyPlayedState) then) =
      _$RecentlyPlayedStateCopyWithImpl<$Res, RecentlyPlayedState>;
  @useResult
  $Res call({List<RecentSongs> recentsdb, List<Songs> dbSongs});
}

/// @nodoc
class _$RecentlyPlayedStateCopyWithImpl<$Res, $Val extends RecentlyPlayedState>
    implements $RecentlyPlayedStateCopyWith<$Res> {
  _$RecentlyPlayedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recentsdb = null,
    Object? dbSongs = null,
  }) {
    return _then(_value.copyWith(
      recentsdb: null == recentsdb
          ? _value.recentsdb
          : recentsdb // ignore: cast_nullable_to_non_nullable
              as List<RecentSongs>,
      dbSongs: null == dbSongs
          ? _value.dbSongs
          : dbSongs // ignore: cast_nullable_to_non_nullable
              as List<Songs>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InitialCopyWith<$Res>
    implements $RecentlyPlayedStateCopyWith<$Res> {
  factory _$$InitialCopyWith(_$Initial value, $Res Function(_$Initial) then) =
      __$$InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RecentSongs> recentsdb, List<Songs> dbSongs});
}

/// @nodoc
class __$$InitialCopyWithImpl<$Res>
    extends _$RecentlyPlayedStateCopyWithImpl<$Res, _$Initial>
    implements _$$InitialCopyWith<$Res> {
  __$$InitialCopyWithImpl(_$Initial _value, $Res Function(_$Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recentsdb = null,
    Object? dbSongs = null,
  }) {
    return _then(_$Initial(
      recentsdb: null == recentsdb
          ? _value._recentsdb
          : recentsdb // ignore: cast_nullable_to_non_nullable
              as List<RecentSongs>,
      dbSongs: null == dbSongs
          ? _value._dbSongs
          : dbSongs // ignore: cast_nullable_to_non_nullable
              as List<Songs>,
    ));
  }
}

/// @nodoc

class _$Initial implements Initial {
  const _$Initial(
      {required final List<RecentSongs> recentsdb,
      required final List<Songs> dbSongs})
      : _recentsdb = recentsdb,
        _dbSongs = dbSongs;

  final List<RecentSongs> _recentsdb;
  @override
  List<RecentSongs> get recentsdb {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentsdb);
  }

  final List<Songs> _dbSongs;
  @override
  List<Songs> get dbSongs {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dbSongs);
  }

  @override
  String toString() {
    return 'RecentlyPlayedState(recentsdb: $recentsdb, dbSongs: $dbSongs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Initial &&
            const DeepCollectionEquality()
                .equals(other._recentsdb, _recentsdb) &&
            const DeepCollectionEquality().equals(other._dbSongs, _dbSongs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_recentsdb),
      const DeepCollectionEquality().hash(_dbSongs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InitialCopyWith<_$Initial> get copyWith =>
      __$$InitialCopyWithImpl<_$Initial>(this, _$identity);
}

abstract class Initial implements RecentlyPlayedState {
  const factory Initial(
      {required final List<RecentSongs> recentsdb,
      required final List<Songs> dbSongs}) = _$Initial;

  @override
  List<RecentSongs> get recentsdb;
  @override
  List<Songs> get dbSongs;
  @override
  @JsonKey(ignore: true)
  _$$InitialCopyWith<_$Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
