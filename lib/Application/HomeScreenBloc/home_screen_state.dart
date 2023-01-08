part of 'home_screen_bloc.dart';

@freezed
class HomeScreenState with _$HomeScreenState {
  const factory HomeScreenState(
      {required List<Songs> dbSongs,
      required bool playerVisibility,
      required List<Songs> mostlysongs,
      required List<Songs> searchsongs,
      required String? value,
      required bool isShuffle,
      required bool isRepeat

      }) = Initial;

  factory HomeScreenState.initial() {
    // dbSongs = box.values.toList();
    return HomeScreenState(
        dbSongs: box.values.toList(),
        playerVisibility: false,
        mostlysongs: mostlySongsPick(), searchsongs: box.values.toList(), value: null, isShuffle: false, isRepeat: false);
  }
}

List<Songs> mostlySongsPick() {
  List<Songs> finalmpsongs = [];
  List<Songs> songlist = box.values.toList();
  int i = 0;
  for (var item in songlist) {
    if (item.count >= 5) {
      finalmpsongs.insert(i, item);
      i = i + 1;
    }
  }
  return finalmpsongs;
}

String updateValue({required String value}){
  return value;
  
}

List<Songs> updateList(String value) {
  print(value);
  return searchresults = dbSongs
      .where((element) =>
          element.songname.toLowerCase().contains(value.toLowerCase()))
      .toList();
      
}



