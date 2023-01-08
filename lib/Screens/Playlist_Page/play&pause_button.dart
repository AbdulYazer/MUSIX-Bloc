
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/Application/HomeScreenBloc/home_screen_bloc.dart';
import 'package:music_player/Application/PlaylistsBloc/playlists_bloc.dart';
import 'package:music_player/Screens/Playlist_Page/Adding_Songs_Playlist.dart';
import 'package:music_player/Screens/Playlist_Page/playlists.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';

import '../../db/Model/model.dart';
import '../../db/functions/db_functions.dart';
import '../../style/style.dart';

List<Songs> songs = [];
bool isPlaying = false;
class PlayPauseButton extends StatelessWidget {
  PlayPauseButton({super.key,required this.playlistname,required this.playlistindex,required this.allplaylistsongs});
  String playlistname;
  int playlistindex;
  List<Songs> allplaylistsongs = [];

  @override
  Widget build(BuildContext context) {
      return BlocBuilder<PlaylistsBloc, PlaylistsState>(
          builder: (context, state) {
                final playlistsong = state.playlistdb.toList();
                songs = playlistsong[playlistindex].playlistsongs;

                if (songs.isEmpty) {
                  return addsongbutton(context);
                }else if(isPlaying==false){
                  return playbutton(context);
                }else{
                  return pausebutton(context);
                }
              }
    );
  }

  Container addsongbutton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return Container(
    width: width * 0.28,
    decoration: BoxDecoration(
      color:Colors.white,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Row(
        children: [
          width10,
          TextButton(
            onPressed: () {
              playbuttonvisible = true;
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddingSongsPlaylist(playlistIndex: playlistindex)));
              BlocProvider.of<PlaylistsBloc>(context).add(const PlaylistsAdded());
            },
            child: const Text('Add Songs', style: TextStyle(color: Colors.black,)),
          )
        ],
      ),
    ),
  );
}

Container playbutton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return Container(
    width: width * 0.23,
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Row(
      children: [
        TextButton.icon(
          icon: const Icon(
            Icons.play_arrow_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            audioPlayerplaylist.open(
              Playlist(audios: playlistsongs, startIndex:0),
              // showNotification: notificationSwitch,
            );
            audioPlayerplaylist.playOrPause();
            BlocProvider.of<HomeScreenBloc>(context).add(const PlayerVisible());
            BlocProvider.of<PlaylistsBloc>(context).add(const PauseVisible());
            isPlaying = true;
            
          },
          label: const Text('Play', style: TextStyle(color: Colors.white)),
        )
      ],
    ),
  );
}

Container pausebutton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return Container(
    width: width * 0.23,
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Row(
      children: [
        TextButton.icon(
          icon: const Icon(
            Icons.pause,
            color: Colors.white,
          ),
          onPressed: () {
            audioPlayerplaylist.playOrPause();
            isPlaying = false;
            BlocProvider.of<PlaylistsBloc>(context).add(const PlayVisible());          
            
          },
          label: const Text('Pause', style: TextStyle(color: Colors.white)),
        )
      ],
    ),
  );
}
}