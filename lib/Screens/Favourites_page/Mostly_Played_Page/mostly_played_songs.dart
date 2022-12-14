import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/Screens/Currently_Playing_Page/currentlyplaying.dart';
import 'package:music_player/db/Model/model.dart';
import 'package:music_player/db/functions/db_functions.dart';
import 'package:music_player/Screens/Search_Page/searchbar.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:music_player/style/style.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../Settings_Page/settings.dart';

class MostlyPlayedScreen extends StatefulWidget {
  const MostlyPlayedScreen({super.key});

  @override
  State<MostlyPlayedScreen> createState() => _MostlyPlayedScreenState();
}

class _MostlyPlayedScreenState extends State<MostlyPlayedScreen> {
  AssetsAudioPlayer audioPlayermost = AssetsAudioPlayer.withId('0');
  List<Audio> songss = [];
  List<RecentSongs> allrecentsongs = recentdbbox.values.toList();
  List<Songs> songlist = box.values.toList();
  @override
  void initState() {
    
    int i = 0;
    for (var item in songlist) {
      if (item.count >= 5) {
        finalmpsongs.insert(i, item);
        i = i + 1;
      }
    }
    for (var items in finalmpsongs) {
      songss.add(Audio.file(items.songurl,
          metas: Metas(
              title: items.songname,
              artist: items.artist,
              id: items.id.toString())));
    }
    super.initState();
  }

  List<Songs> finalmpsongs = [];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Songs> mpsongsbox, _) {
          RecentSongs recents;
          if (finalmpsongs.isNotEmpty) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      recents = RecentSongs(
                              songname: allrecentsongs[index].songname,
                              artist: allrecentsongs[index].artist,
                              duration: allrecentsongs[index].duration,
                              songurl: allrecentsongs[index].songurl,
                              id: allrecentsongs[index].id,
                              count: allrecentsongs[index].count
                            );
                            updateRecentlyPlayed(recents);
                            final songIndex =allDbSongs.indexWhere((e) => e.songname.toString() == allrecentsongs[index].songname.toString());
                            songCount(allDbSongs[songIndex], songIndex);
                      audioPlayer.open(
                        Playlist(audios: songss, startIndex: index),
                        showNotification: notificationSwitch,
                      );

                      setState(() {
                        currentlyplayingvisibility = true;
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CurrentlyPlaying(audioPlayer: audioPlayermost,)));
                    },
                    leading: QueryArtworkWidget(
                      artworkBorder: BorderRadius.circular(15),
                      artworkHeight: 90,
                      artworkWidth: 60,
                      id: finalmpsongs[index].id,
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
                      finalmpsongs[index].songname,
                      style: songnametext,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                );
              },
              itemCount: finalmpsongs.length < 10 ? finalmpsongs.length : 10,
            );
          
          } else {
            return const Center(
              child: Text(
                'No Mostly Played Songs',
                style: songnametext,
              ),
            );
          }
          
          }
    );
  }
}