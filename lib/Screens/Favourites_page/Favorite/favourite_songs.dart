import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/Settings_Page/settings.dart';
import 'package:music_player/Screens/Currently_Playing_Page/currentlyplaying.dart';
import 'package:music_player/Screens/Search_Page/searchbar.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:music_player/style/style.dart';
import 'package:music_player/widgets/favorite_function.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../db/Model/model.dart';
import '../../../db/functions/db_functions.dart';

class FavoriteSongs extends StatefulWidget {
  const FavoriteSongs({super.key});

  @override
  State<FavoriteSongs> createState() => _FavoriteSongsState();
}

List<Audio> allsongs = [];

class _FavoriteSongsState extends State<FavoriteSongs> {
  AssetsAudioPlayer audioPlayerfav = AssetsAudioPlayer.withId('0');
  final dbsongs = SongBox.getInstance().values.toList();

  @override
  void initState() {
    addfavfromdb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Favsongs>('favsongs').listenable(),
        builder: (context, Box<Favsongs> alldbfavsongs, child) {
          List<Favsongs> allfavsongs = alldbfavsongs.values.toList();
          RecentSongs recents;
          if (allfavsongs.isEmpty) {
            return const Center(
              child: Text(
                'No Favorite songs',
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
                  recents = RecentSongs(
                      songname: allfavsongs[index].songname,
                      artist: allfavsongs[index].artist,
                      id: int.parse(allfavsongs[index].id),
                      duration: int.parse(allfavsongs[index].duration),
                      songurl: allfavsongs[index].songurl,
                      count: 0);
                  updateRecentlyPlayed(recents);
                  final songIndex =allDbSongs.indexWhere((e) => e.songname.toString() == allfavsongs[index].songname.toString());
                  songCount(allDbSongs[songIndex], songIndex);
                  setState(() {});
                  audioPlayerfav.open(
                    Playlist(audios: allsongs, startIndex: index),
                    showNotification: notificationSwitch,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CurrentlyPlaying(
                          audioPlayer: audioPlayerfav,
                        );
                      },
                    ),
                  );
                },
                leading: QueryArtworkWidget(
                  artworkBorder: BorderRadius.circular(15),
                  artworkHeight: 90,
                  artworkWidth: 60,
                  id: int.parse(allfavsongs[index].id),
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
                  allfavsongs[index].songname,
                  style: songnametext,
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  softWrap: false,
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(
                      () {},
                    );
                    // print('hi');

                    favdbsongs.deleteAt(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.black,
                        duration: const Duration(seconds: 1),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        content: Text(
                            '${allfavsongs[index].songname} Removed from favourites'),
                      ),
                    );
                    addfavfromdb();
                  },
                  //color: selectedItemColor,
                ),
              );
            },
            itemCount: allfavsongs.length,
          );
        });
  }
}

addfavfromdb() {
  final favsongs = Hive.box<Favsongs>('favsongs').values.toList();
  allsongs.clear();
  for (var items in favsongs) {
    allsongs.add(Audio.file(items.songurl,
        metas: Metas(
          artist: items.artist,
          title: items.songname,
          id: items.id.toString(),
        )));
    //print(favsongs.map((e) => e.songname));
  }
}
