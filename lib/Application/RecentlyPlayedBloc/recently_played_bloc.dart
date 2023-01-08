import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:music_player/db/functions/db_functions.dart';

import '../../db/Model/model.dart';

part 'recently_played_event.dart';
part 'recently_played_state.dart';
part 'recently_played_bloc.freezed.dart';

class RecentlyPlayedBloc extends Bloc<RecentlyPlayedEvent, RecentlyPlayedState> {
  RecentlyPlayedBloc() : super(RecentlyPlayedState.initial()) {
    on<RecentlyPlayedEvent>((event, emit) {
      emit(RecentlyPlayedState(recentsdb: recentdbbox.values.toList(), dbSongs: box.values.toList()));
    });
  }
}
