import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/Screens/Currently_Playing_Page/currentlyplaying.dart';
import 'package:music_player/db/Model/model.dart';
import 'package:music_player/db/functions/db_functions.dart';
import 'package:music_player/Screens/Search_Page/searchbar.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:music_player/style/style.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../Application/HomeScreenBloc/home_screen_bloc.dart';
import '../../../Application/RecentlyPlayedBloc/recently_played_bloc.dart';
import '../../../Settings_Page/settings.dart';

class MostlyPlayedScreen extends StatelessWidget {
  MostlyPlayedScreen({super.key});

  AssetsAudioPlayer audioPlayermost = AssetsAudioPlayer.withId('0');

  // List<RecentSongs> allrecentsongs = recentdbbox.values.toList();
  late List<Songs> songlist ;

  List<Audio> songss = [];

  @override
  Widget build(BuildContext context) {
    // return ValueListenableBuilder(
    //     valueListenable: box.listenable(),
    //     builder: (context, Box<Songs> mpsongsbox, _) {
    RecentSongs recents;
    
    // if (state.finalmpsongs.isNotEmpty) {
      return BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          songlist = state.dbSongs.toList();
          songss.clear();
          for (var items in mostlySongsPick()) {
            songss.add(Audio.file(items.songurl,
                metas: Metas(
                    title: items.songname,
                    artist: items.artist,
                    id: items.id.toString())));
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    audioPlayer.open(
                      Playlist(audios: songss, startIndex: index),
                      showNotification: notificationSwitch,
                    );
                    BlocProvider.of<HomeScreenBloc>(context).add(const PlayerVisible());
                    recents = RecentSongs(
                        songname: state.mostlysongs[index].songname,
                        artist: state.mostlysongs[index].artist,
                        duration: state.mostlysongs[index].duration,
                        songurl: state.mostlysongs[index].songurl,
                        id: state.mostlysongs[index].id,
                        count: state.mostlysongs[index].count);
                    print(recents.songname);
                    updateRecentlyPlayed(recents);
                    BlocProvider.of<RecentlyPlayedBloc>(context)
                        .add(const Recently());
                    final songIndex = allDbSongs.indexWhere((e) =>
                        e.songname.toString() ==
                        state.mostlysongs[index].songname.toString());
                    songCount(allDbSongs[songIndex], songIndex);
                    BlocProvider.of<HomeScreenBloc>(context).add(const Mostly());
                    
                    // setState(() {
                    //   currentlyplayingvisibility = true;
                    // });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CurrentlyPlaying(
                              audioPlayer: audioPlayermost,
                            )));
                  },
                  leading: QueryArtworkWidget(
                    artworkBorder: BorderRadius.circular(15),
                    artworkHeight: 90,
                    artworkWidth: 60,
                    id: state.mostlysongs[index].id,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/currentplaylogo1.png',
                        width: 60,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    state.mostlysongs[index].songname,
                    style: songnametext,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              );
            },
            itemCount: state.mostlysongs.length < 10 ? state.mostlysongs.length : 10,
          );
        },
      );
    // } else {
      // return const Center(
      //   child: Text(
      //     'No Mostly Played Songs',
      //     style: songnametext,
      //   ),
      // );
    // }

    //       }
    // );
  }
}
