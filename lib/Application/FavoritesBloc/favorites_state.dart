part of 'favorites_bloc.dart';

@freezed
class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    required List<Favsongs> favsongs,
    required List<Songs> dbSongs,
  }) = Initial;

  factory FavoritesState.initial() {
    // dbSongs = box.values.toList();
    return FavoritesState(favsongs: favdbsongs.values.toList(),dbSongs: box.values.toList());
  }
}
