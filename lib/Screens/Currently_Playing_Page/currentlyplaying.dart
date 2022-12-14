import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/Screens/Playlist_Page/Add_to_playlist.dart';
import 'package:music_player/Screens/Playlist_Page/play&pause_button.dart';
import 'package:music_player/db/Model/model.dart';
import 'package:music_player/db/functions/db_functions.dart';
import 'package:music_player/Screens/Search_Page/searchbar.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:music_player/style/style.dart';
import 'package:music_player/widgets/favorite_function.dart';
import 'package:music_player/widgets/heightbox_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../Favourites_page/Favorite/favourite_fuction.dart';

bool isRepeat = false;
bool isShuffle = false;
List<Favsongs> fav = [];

class CurrentlyPlaying extends StatefulWidget {
  final AssetsAudioPlayer audioPlayer;

  const CurrentlyPlaying({
    required this.audioPlayer,
    super.key,
  });

  @override
  State<CurrentlyPlaying> createState() => _CurrentlyPlayingState();
}
class _CurrentlyPlayingState extends State<CurrentlyPlaying> {
  //final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  @override
  Widget build(BuildContext context) {
    fav = favdbsongs.values.toList();
    List<Songs> dbSongs = box.values.toList();
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Currently Playing'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //heightbox(height: 20),
            SongDetails(width: width),
            IconButton(
                onPressed: () {
                  audioPlayer.seekBy(const Duration(seconds: 10));
                },
                icon: const Icon(
                  Icons.fast_forward,
                  color: Colors.white,
                )),
            audioPlayer.builderCurrent(builder: (context, playing) {
              return playlist(playing, dbSongs);
            }),
            IconButton(
                onPressed: () {
                  audioPlayer.seekBy(const Duration(seconds: -10));
                },
                icon: const Icon(
                  Icons.fast_rewind,
                  color: Colors.white,
                )),
            //heightbox(height: 40),
            Center(
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.expand_more_sharp,
                      color: Colors.white,
                    ))),
          ],
        ),
      )),
    );
  }

  Builder playlist(
    Playing playing,
    List<Songs> dbSongs,
  ) {
     RecentSongs recents;
    return Builder(
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: isShuffle
                  ? const Icon(
                      Icons.shuffle_rounded,
                      color: Colors.blue,
                    )
                  : const Icon(Icons.shuffle_rounded),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  if (isShuffle == true) {
                    isShuffle = false;
                    audioPlayer.toggleShuffle();
                  } else {
                    isShuffle = true;
                    audioPlayer.toggleShuffle();
                  }
                });
              },
              padding: EdgeInsets.zero,
              splashRadius: 18,
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous_sharp),
              color: Colors.white,
              onPressed: () {
                audioPlayer.previous();
                recents = RecentSongs(
                      songname: dbSongs[playing.index].songname,
                      artist: dbSongs[playing.index].artist,
                      id: dbSongs[playing.index].id,
                      duration: dbSongs[playing.index].duration,
                      songurl: dbSongs[playing.index].songurl,
                      count: 0);
                      updateRecentlyPlayed(recents);
                      final songIndex =allDbSongs.indexWhere((e) => e.songname.toString() == dbSongs[playing.index].songname.toString());
                      songCount(allDbSongs[songIndex], songIndex);
              },
              padding: EdgeInsets.zero,
              splashRadius: 18,
            ),
            PlayerBuilder.isPlaying(
                player: audioPlayer,
                builder: (context, isPlaying) {
                  return IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    color: Colors.blue,
                    onPressed: () {
                      audioPlayer.playOrPause();
                    },
                    padding: EdgeInsets.zero,
                    splashRadius: 18,
                  );
                }),
            IconButton(
              icon: const Icon(Icons.skip_next_sharp),
              color: Colors.white,
              onPressed: !playing.hasNext
                  ? () {
                      //audioPlayer.pause();
                  }
                  : () {
                      audioPlayer.next();
                      recents = RecentSongs(
                      songname: dbSongs[playing.index].songname,
                      artist: dbSongs[playing.index].artist,
                      id: dbSongs[playing.index].id,
                      duration: dbSongs[playing.index].duration,
                      songurl: dbSongs[playing.index].songurl,
                      count: 0);
                      updateRecentlyPlayed(recents);
                      final songIndex =allDbSongs.indexWhere((e) => e.songname.toString() == dbSongs[playing.index].songname.toString());
                      songCount(allDbSongs[songIndex], songIndex);
                  },
              padding: EdgeInsets.zero,
              splashRadius: 18,
            ),
            IconButton(
              icon: isRepeat == true
                  ? const Icon(
                      Icons.repeat_one_rounded,
                      color: Colors.blue,
                    )
                  : const Icon(Icons.repeat_outlined),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  if (isRepeat == false) {
                    isRepeat = true;
                    audioPlayer.setLoopMode(LoopMode.single);
                  } else {
                    isRepeat = false;
                    audioPlayer.setLoopMode(LoopMode.none);
                  }
                });
              },
              padding: EdgeInsets.zero,
              splashRadius: 18,
            ),
          ],
        );
      },
    );
  }
}

// bool isFavorite = false;

class SongDetails extends StatefulWidget {
  const SongDetails({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  State<SongDetails> createState() => _SongDetailsState();
}

class _SongDetailsState extends State<SongDetails> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  // @override
  // void initState() {
  //   fav = favdbsongs.values.toList();
  //   List<Songs> dbSongs = box.values.toList();
  //   setState(() {
  //     for (var i=0;i<=dbSongs.length;i++){
  //     if(fav.where((element) => element.songname == dbSongs[i].songname).isEmpty){
  //       isFavorite = false;
  //     }
  //     else{
  //       isFavorite = true;
  //     }
  //     }
  //   });
  //   super.initState();
  //   // audioPlayer;
  // }

  @override
  Widget build(
    BuildContext context,
  ) {
    return audioPlayer.builderCurrent(
      builder: (context, playing) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: widget.width - 100,
                  width: widget.width - 100,
                  child: QueryArtworkWidget(
                    id: int.parse(playing.audio.audio.metas.id!),
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'assets/images/currentplaylogo1.png',
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
              ],
            ),
            heightbox(height: 20),
            Text(
              audioPlayer.getCurrentAudioTitle,
              style: songnametext1,
              overflow: TextOverflow.clip,
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
            ),
            heightbox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    audioPlayer.getCurrentAudioArtist,
                    style: singernametext1,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          playlistBottomSheet(context, playing.index);
                        },
                        icon: const Icon(
                          Icons.playlist_add,
                          color: Colors.white,
                        )),
                    audioPlayer.builderCurrent(
                      builder: (context, playing) {
                        return FavIcon(
                          index: dbSongs.indexWhere((element) =>
                              element.songname ==
                              playing.audio.audio.metas.title),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
            heightbox(height: 20),
            audioPlayer.builderCurrentPosition(
              builder: (context, currentPosition) {
                return Column(
                  children: [
                    Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      thumbColor: Colors.white,
                      value: currentPosition.inSeconds.toDouble(),
                      min: 0.0,
                      max: playing.audio.duration.inSeconds.toDouble(),
                      onChanged: (value) async {
                        final newDuration = Duration(seconds: value.toInt());
                        await audioPlayer.seek(newDuration);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${currentPosition.toString().split(':')[1]}:${currentPosition.toString().split(':')[2].split('.')[0]}',
                            style: singernametext,
                          ),
                          Text(
                            '${playing.audio.duration.toString().split(':')[1]}:${playing.audio.duration.toString().split(':')[2].split('.')[0]}',
                            style: singernametext,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            // heightbox(height: 20),
            // heightbox(height: 20),
          ],
        );
      },
    );
  }
}
