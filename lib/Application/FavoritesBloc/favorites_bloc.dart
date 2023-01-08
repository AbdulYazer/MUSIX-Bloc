import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_player/Application/HomeScreenBloc/home_screen_bloc.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:music_player/db/functions/db_functions.dart';

import '../../db/Model/model.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';
part 'favorites_bloc.freezed.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesState.initial()) {
    on<FavoritesEvent>((event, emit) {
      emit(FavoritesState(favsongs: favdbsongs.values.toList(),dbSongs: box.values.toList()));
    });

    // on<PlayerVisible>((event, emit) {
    //   emit(state.copyWith(playerVisibility: true));
    // });
  }
}
