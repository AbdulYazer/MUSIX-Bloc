part of 'playlists_bloc.dart';

@freezed
class PlaylistsState with _$PlaylistsState {
  const factory PlaylistsState({
    required List<Playlists> playlistdb,
    required bool playAndPauseVisibility,
    required bool textformVisibility,
    required bool playbuttonvisible
  }) = Initial;

  factory PlaylistsState.initial(){
    return PlaylistsState(playlistdb: playlistsbox.values.toList(), playAndPauseVisibility: isPlaying, textformVisibility: false, playbuttonvisible: false);
  }

  
}
