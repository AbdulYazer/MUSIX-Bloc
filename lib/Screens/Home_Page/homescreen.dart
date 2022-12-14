import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/Screens/Favourites_page/Favorite/favourite_songs.dart';
import 'package:music_player/Screens/Playlist_Page/Add_to_playlist.dart';
import 'package:music_player/db/Model/model.dart';
import 'package:music_player/Screens/Search_Page/searchbar.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:music_player/widgets/app_bar.dart';
import 'package:music_player/Screens/Currently_Playing_Page/currentlyplaying.dart';
import 'package:music_player/style/style.dart';
import 'package:music_player/widgets/favorite_function.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../Favourites_page/Favorite/favourite_fuction.dart';
import '../../Settings_Page/settings.dart';
import '../../db/functions/db_functions.dart';

//bool currentlyplayingvisibility = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
List<Audio> allSongs = [];

class _HomeScreenState extends State<HomeScreen> {
  final box = SongBox.getInstance();
  

  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId('0');
  int count = 0; 

  @override
  void initState() {
    super.initState();
    List<Songs> dbSongs = box.values.toList();
    allSongs.clear();
    // box.clear();
    // print(box.length);

    //print(dbSongs);
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

  @override
  Widget build(BuildContext context) {
    List<Songs> allDbSongs = box.values.toList();
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
            Expanded(
              child: ValueListenableBuilder<Box<Songs>>(
                valueListenable: box.listenable(),
                builder: (context, Box<Songs> allboxsong, child) {
                  List<Songs> allDbSongs = allboxsong.values.toList();
                  // if (allDbSongs == null) {
                  //   return const Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                  // }
                  if (allDbSongs.isEmpty) {
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
                      Songs songs = allDbSongs[index];
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
                                        ListTile(
                                          leading: const Icon(Icons.favorite),
                                          title: const Text(
                                            'Add to favorite',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onTap: () {
                                            addtofav(context, index: index);
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading:
                                              const Icon(Icons.playlist_add),
                                          title: const Text(
                                            'Add to playlist',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onTap: () {
                                            playlistBottomSheet(context, index);
                                          },
                                        ),
                                      ],
                                    );
                                  }).then((value) => setState(() {}));
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
                              count: songs.count
                            );
                            updateRecentlyPlayed(recents);
                            songCount(songs,index);
                            setState(() {
                              currentlyplayingvisibility = true;
                            });
                            addfavfromdb();
                            _audioPlayer.open(
                                Playlist(audios: allSongs, startIndex: index),
                                loopMode: LoopMode.playlist,
                                showNotification: notificationSwitch
                            );
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return CurrentlyPlaying(audioPlayer: audioPlayer);
                            }));
                          });
                    },
                    itemCount: allDbSongs.length,
                  );
                },
              ),
            ),
            //heightbox(height: 80),
          ],
        ),
      ),
      bottomSheet: Visibility(
        visible: currentlyplayingvisibility,
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
      ),
    );
  }
}

ValueListenableBuilder miniPlayer() {
  //print('value listenable rebuild');
  return ValueListenableBuilder<Box<Favsongs>>(
    valueListenable: favdbsongs.listenable(),
    builder: (context, value, child) {
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
                children: const [
                  AudioFileHome(),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class AudioFileHome extends StatefulWidget {
  const AudioFileHome({super.key});

  @override
  State<AudioFileHome> createState() => _AudioFileHomeState();
}

class _AudioFileHomeState extends State<AudioFileHome> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  // @override
  // void dispose(){
  //   audioPlayer.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Favsongs>>(
        valueListenable: favdbsongs.listenable(),
        builder: ((context, value, child) {
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
                        audioPlayer.getCurrentAudioTitle.toString().length > 26 ?
                        audioPlayer.getCurrentAudioTitle.substring(0,26).toString() : 
                        audioPlayer.getCurrentAudioTitle.toString(),
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
                            Duration newDuration =
                                Duration(seconds: value.toInt());
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
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow),
                            color: Colors.blue,
                            onPressed: () {
                              audioPlayer.playOrPause();
                            },
                            padding: EdgeInsets.zero,
                            splashRadius: 18,
                          ),
                          FavIcon(
                            index: dbSongs.indexWhere((element) =>
                              element.songname ==
                              playing.audio.audio.metas.title),
                          ),
                        ],
                      );
                    }),

                //playfav(),
                // SizedBox(
                //   width: 75,child: playfav()),
              ],
            );
          });
        }));

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
