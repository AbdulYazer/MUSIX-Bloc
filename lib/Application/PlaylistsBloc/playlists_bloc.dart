import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_player/Screens/Playlist_Page/play&pause_button.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:music_player/db/functions/db_functions.dart';

import '../../db/Model/model.dart';

part 'playlists_event.dart';
part 'playlists_state.dart';
part 'playlists_bloc.freezed.dart';

class PlaylistsBloc extends Bloc<PlaylistsEvent, PlaylistsState> {
  PlaylistsBloc() : super(PlaylistsState.initial()) {
    on<PlaylistsEvent>((event, emit) {
      emit(PlaylistsState(playlistdb: playlistsbox.values.toList(), playAndPauseVisibility: isPlaying, textformVisibility: false, playbuttonvisible: false));
    });

    on<PauseVisible>((event, emit) {
      emit(state.copyWith(playAndPauseVisibility: true));
    });
    on<PlayVisible>((event, emit) {
      emit(state.copyWith(playAndPauseVisibility: false));
    });

    on<TextFieldVisible>((event, emit) {
      emit(state.copyWith(textformVisibility: true));
    });

    on<TextFieldNotVisible>((event, emit) {
      emit(state.copyWith(textformVisibility: false));
    });

    on<PlayButtonVisible>((event, emit) {
      emit(state.copyWith(playbuttonvisible: true));
    });

    on<PlayButtonNotVisible>((event, emit) {
      emit(state.copyWith(playbuttonvisible: false));
    });


    
  }
}
