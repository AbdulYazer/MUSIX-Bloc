import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_player/widgets/favorite_function.dart';
import '../../Screens/Search_Page/searchbar.dart';
import '../../Screens/Splash_Page/splash.dart';
import '../../db/Model/model.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';
part 'home_screen_bloc.freezed.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenState.initial()) {
    on<HomeScreenEvent>((event, emit) {
      emit(HomeScreenState(
          dbSongs: state.dbSongs,
          playerVisibility: false,
          mostlysongs: mostlySongsPick(),
          searchsongs: box.values.toList(),
          value: null, isRepeat: false, isShuffle: false));
    });

    on<PlayerVisible>((event, emit) {
      emit(state.copyWith(playerVisibility: true));
    });

    on<Mostly>((event, emit) {
      emit(state.copyWith(mostlysongs: mostlySongsPick()));
    });

    // on<UpdatedList>((event, emit) {
    //   emit(state.copyWith(searchsongs: updateList(state.value!)));
    // });
    on<UpdateValues>((event, emit) {
      // emit(state.copyWith(value: event.value));
      final newupdate = updateList(event.value);
      log(newupdate.toString());
      emit(state.copyWith(searchsongs: newupdate));
    });

    on<ClearSongs>((event, emit) {
      emit(state.copyWith(value: null));
    });

    on<IsShuffle>((event, emit) {
      emit(state.copyWith(isShuffle: true));
    });
    on<IsNotShuffle>((event, emit) {
      emit(state.copyWith(isShuffle: false));
    });

    on<IsRepeat>((event, emit) {
      emit(state.copyWith(isRepeat: true));
    });
     on<IsNotRepeat>((event, emit) {
      emit(state.copyWith(isRepeat: false));
    });
  }
}
