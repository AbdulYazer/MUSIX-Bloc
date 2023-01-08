part of 'home_screen_bloc.dart';

@freezed
class HomeScreenEvent with _$HomeScreenEvent {
  const factory HomeScreenEvent.started() = _Started;

  const factory HomeScreenEvent.playerVisible() = PlayerVisible;

  const factory HomeScreenEvent.mostly() = Mostly;

  const factory HomeScreenEvent.search() = Search;

  const factory HomeScreenEvent.updateValues({
    required String value
  }) = UpdateValues;

  const factory HomeScreenEvent.clearSongs() = ClearSongs;

  const factory HomeScreenEvent.isShuffle() = IsShuffle;
  const factory HomeScreenEvent.isNotShuffle() = IsNotShuffle;

  const factory HomeScreenEvent.isRepeat() = IsRepeat;
  const factory HomeScreenEvent.isNotRepeat() = IsNotRepeat;



  
  

  // const factory HomeScreenEvent.updatedList({
  //   required List<Songs> updatedSongList
  // }) = UpdatedList;
  
  
  
  
  
}