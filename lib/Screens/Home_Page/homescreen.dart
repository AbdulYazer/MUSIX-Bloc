import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/Application/RecentlyPlayedBloc/recently_played_bloc.dart';
import 'package:music_player/Screens/Favourites_page/Favorite/favourite_songs.dart';
import 'package:music_player/Screens/Playlist_Page/Add_to_playlist.dart';
import 'package:music_player/db/Model/model.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:music_player/widgets/app_bar.dart';
import 'package:music_player/Screens/Currently_Playing_Page/currentlyplaying.dart';
import 'package:music_player/style/style.dart';
import 'package:music_player/widgets/favorite_function.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../Application/FavoritesBloc/favorites_bloc.dart';
import '../../Application/HomeScreenBloc/home_screen_bloc.dart';
import '../Favourites_page/Favorite/favourite_fuction.dart';
import '../../Settings_Page/settings.dart';
import '../../db/functions/db_functions.dart';

//bool currentlyplayingvisibility = false;

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final box = SongBox.getInstance();

  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  Widget build(BuildContext context) {
    // List<Songs> allDbSongs = box.values.toList();
    RecentSongs recents;
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: appBarWidget(context, iconButton2: Icons.search_outlined),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Songs',
              style: text1,
            ),
            Expanded(child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
              builder: (context, state) {
                addtoplayer(dbSongs: state.dbSongs);
                print('hello rebuilding again');
                if (state.dbSongs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No songs found',
                      style: songnametext,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(
                      top: 10, bottom: currentlyplayingvisibility ? 80 : 10),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Songs songs = state.dbSongs[index];
                    return ListTile(
                        leading: QueryArtworkWidget(
                          artworkBorder: BorderRadius.circular(15),
                          artworkHeight: 90,
                          artworkWidth: 60,
                          id: songs.id,
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
                        //  const CircleAvatar(
                        //   backgroundColor: Colors.redAccent,
                        //   child: Icon(
                        //     Icons.music_note,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          songs.songname,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          style: songnametext,
                        ),
                        subtitle: Text(
                          songs.artist,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          style: singernametext,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      BlocBuilder<FavoritesBloc, FavoritesState>(
                                        builder: (context, state) {
                                          return ListTile(
                                            leading: const Icon(Icons.favorite),
                                            title: const Text(
                                              'Add to favorite',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onTap: () {
                                              addtofav(context, index: index);
                                              BlocProvider.of<FavoritesBloc>(context).add(const FavoritesEvent.started());
                                              // setState(() {});
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.playlist_add),
                                        title: const Text(
                                          'Add to playlist',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onTap: () {
                                          playlistBottomSheet(context, index);
                                        },
                                      ),
                                    ],
                                  );
                                 }).then((value) {} );
                                //  setState(() {});
                          },
                          icon: const Icon(
                            Icons.more_vert_sharp,
                          ),
                          color: Colors.white,
                          splashRadius: 18,
                        ),
                        onTap: () {
                          //print(songs.songname);
                          recents = RecentSongs(
                              songname: songs.songname,
                              artist: songs.artist,
                              duration: songs.duration,
                              songurl: songs.songurl,
                              id: songs.id,
                              count: songs.count);
                          updateRecentlyPlayed(recents);
                          songCount(songs, index);
                          BlocProvider.of<HomeScreenBloc>(context).add(const Mostly());
                          BlocProvider.of<HomeScreenBloc>(context)
                              .add(const PlayerVisible());
                          BlocProvider.of<RecentlyPlayedBloc>(context). add(const Recently());   

                          // setState(() {
                          //   currentlyplayingvisibility = true;
                          // });
                          addfavfromdb();
                          _audioPlayer.open(
                              Playlist(audios: allSongs, startIndex: index),
                              loopMode: LoopMode.playlist,
                              showNotification: notificationSwitch);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return CurrentlyPlaying(audioPlayer: audioPlayer);
                          }));
                        });
                  },
                  itemCount: state.dbSongs.length,
                );
              },
            )),
            //heightbox(height: 80),
          ],
        ),
      ),
      bottomSheet: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          return Visibility(
            visible: state.playerVisibility,
            child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    audioPlayer.next();
                  } else if (details.primaryVelocity! > 0) {
                    audioPlayer.previous();
                  }
                },
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) =>
                          CurrentlyPlaying(audioPlayer: audioPlayer))));
                },
                child: Container(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    child: miniPlayer())),
          );
        },
      ),
    );
  }

  void addtoplayer({required List<Songs> dbSongs}) {
    allSongs.clear();
    for (var item in dbSongs) {
      allSongs.add(
        Audio.file(
          item.songurl,
          metas: Metas(
            artist: item.artist,
            title: item.songname,
            id: item.id.toString(),
          ),
        ),
      );
    }
  }
}

List<Audio> allSongs = [];

Widget miniPlayer() {
  return Container(
    // width: 400,
    height: 80,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(20),
      color: const Color.fromARGB(255, 78, 76, 76),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        audioPlayer.builderCurrent(
          builder: (context, playing) {
            return Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 57, 57, 57)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: QueryArtworkWidget(
                    nullArtworkWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/currentplaylogo1.png',
                          fit: BoxFit.cover,
                        )),
                    artworkBorder: BorderRadius.circular(20),
                    id: int.parse(playing.audio.audio.metas.id!),
                    type: ArtworkType.AUDIO,
                    keepOldArtwork: true,
                  ),
                ));
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: [
              AudioFileHome(),
            ],
          ),
        ),
      ],
    ),
  );
}

class AudioFileHome extends StatelessWidget {
  AudioFileHome({super.key});

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  // @override
  @override
  Widget build(BuildContext context) {
    // return ValueListenableBuilder<Box<Favsongs>>(
    //     valueListenable: favdbsongs.listenable(),
    //     builder: ((context, value, child) {
    return audioPlayer.builderCurrent(builder: (context, playing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          audioPlayer.builderCurrentPosition(
              builder: (context, currentPosition) {
            return Column(
              children: [
                Text(
                  audioPlayer.getCurrentAudioTitle.toString().length > 26
                      ? audioPlayer.getCurrentAudioTitle
                          .substring(0, 26)
                          .toString()
                      : audioPlayer.getCurrentAudioTitle.toString(),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbColor: Colors.transparent,
                      thumbShape: const RoundSliderThumbShape(
                          disabledThumbRadius: 0, enabledThumbRadius: 0)),
                  child: Slider(
                    thumbColor: Colors.white,
                    value: currentPosition.inSeconds.toDouble(),
                    min: 0.0,
                    max: playing.audio.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      Duration newDuration = Duration(seconds: value.toInt());
                      audioPlayer.seek(newDuration);
                    },
                  ),
                ),
              ],
            );
          }),
          PlayerBuilder.isPlaying(
              player: audioPlayer,
              builder: (context, isPlaying) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      color: Colors.blue,
                      onPressed: () {
                        audioPlayer.playOrPause();
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: 18,
                    ),
                    BlocBuilder<FavoritesBloc, FavoritesState>(
                      builder: (context, state) {
                        return FavIcon(
                          dbSongs: state.dbSongs,
                          index: state.dbSongs.indexWhere((element) =>
                              element.songname ==
                              playing.audio.audio.metas.title),
                        );
                      },
                    ),
                  ],
                );
              }),

          //playfav(),
          // SizedBox(
          //   width: 75,child: playfav()),
        ],
      );
      // });
    });

//   Widget playfav(){
//   return Stack(
//     children: [
//       Positioned(
//         child: PlayerBuilder.isPlaying(
//               player: audioPlayer,
//               builder: (context, isPlaying) {
//                 return IconButton(
//                   icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//                   color: Colors.blue,
//                   onPressed: () {
//                     audioPlayer.playOrPause();
//                   },
//                   padding: EdgeInsets.zero,
//                   splashRadius: 18,
//                 );
//               }),),
//       Positioned(
//         left: 40,
//         child: IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)))
//     ],
//   );
// }
  }
}
