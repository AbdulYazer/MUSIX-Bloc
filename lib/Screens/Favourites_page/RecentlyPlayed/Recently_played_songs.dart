import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/Screens/Favourites_page/Favorite/favourite_songs.dart';
import 'package:music_player/db/Model/model.dart';
import 'package:music_player/db/functions/db_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../Settings_Page/settings.dart';
import '../../Currently_Playing_Page/currentlyplaying.dart';
import '../../Home_Page/homescreen.dart';
import '../../Search_Page/searchbar.dart';
import '../../../style/style.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({super.key});

  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}

List<RecentSongs> allrecentsongs = [];
// List<RecentSongs> dbrecent = recentdbbox.values.toList().reversed.toList();
List<Audio> recentsongs = [];

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  AssetsAudioPlayer audioPlayerrecent = AssetsAudioPlayer.withId('0');

  // List<Songs> dbSongs = SongBox.getInstance().values.toList().reversed.toList();

  @override
  void initState() {
    convertToAudios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<RecentSongs>('RecentSongs').listenable(),
        builder: (context, Box<RecentSongs> alldbRecentSongs, child) {
          allrecentsongs = alldbRecentSongs.values.toList().reversed.toList();
          convertToAudios();
          if (allrecentsongs.isEmpty) {
            return const Center(
              child: Text(
                'No Recent songs',
                style: songnametext,
              ),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                onTap: () {
                  setState(() {
                    currentlyplayingvisibility = true;
                  });
                  //print(dbrecent);
                  final recents = RecentSongs(
                      songname: allrecentsongs[index].songname,
                      artist: allrecentsongs[index].artist,
                      duration: allrecentsongs[index].duration,
                      songurl: allrecentsongs[index].songurl,
                      id: allrecentsongs[index].id,
                      count: allrecentsongs[index].count);
                  updateRecentlyPlayed(recents);
                  final songIndex =allDbSongs.indexWhere((e) => e.songname.toString() == allrecentsongs[index].songname.toString());
                  songCount(allDbSongs[songIndex], songIndex);
                  setState(() {});
                  audioPlayerrecent.open(
                    Playlist(
                        audios: recentsongs,
                        startIndex: allrecentsongs.indexWhere((element) =>
                            element.songname ==
                            allrecentsongs[index].songname)),
                            showNotification: notificationSwitch,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CurrentlyPlaying(
                          audioPlayer: audioPlayerrecent,
                        );
                      },
                    ),
                  );
                },
                leading: QueryArtworkWidget(
                  artworkBorder: BorderRadius.circular(15),
                  artworkHeight: 90,
                  artworkWidth: 60,
                  id: allrecentsongs[index].id,
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
                  allrecentsongs[index].songname,
                  style: songnametext,
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  softWrap: false,
                ),
              );
            },
            itemCount: allrecentsongs.length < 10 ? allrecentsongs.length : 10,
          );
        });
  }
}

convertToAudios() {
  recentsongs.clear();
  for (var item in allrecentsongs) {
    recentsongs.add(Audio.file(item.songurl,
        metas: Metas(
          title: item.songname,
          artist: item.artist,
          id: item.id.toString(),
        )));
  }
}
