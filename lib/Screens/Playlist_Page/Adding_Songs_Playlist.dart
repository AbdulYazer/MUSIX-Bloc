import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../db/Model/model.dart';
import '../../db/functions/db_functions.dart';
import '../../style/style.dart';

class AddingSongsPlaylist extends StatefulWidget {
  AddingSongsPlaylist({super.key, required this.playlistIndex});
  int playlistIndex;
  @override
  State<AddingSongsPlaylist> createState() => _AddingSongsPlaylistState();
}

class _AddingSongsPlaylistState extends State<AddingSongsPlaylist> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  List<Songs> song = SongBox.getInstance().values.toList();
  List<Playlists> psongs = playlistsbox.values.toList();
  final box = SongBox.getInstance();
  List<Audio> allSongs = [];
  bool isAlreadyAdded = false;

  @override
  void initState() {
    super.initState();
    List<Songs> dbSongs = box.values.toList();
    allSongs.clear();
    for (var item in dbSongs) {
      return allSongs.add(
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
    return Scaffold(
        backgroundColor: bgcolor,
        appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          margin: const EdgeInsets.only(right: 200, top: 40),
          child: const Image(
            image: AssetImage('assets/images/Logo2.png'),
            height: 30,
          ),
        ),
        backgroundColor: Colors.black,
      ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Songs',
                style: text1,
              ),
              Expanded(
                  child: ValueListenableBuilder<Box<Songs>>(
                valueListenable: box.listenable(),
                builder: (context, Box<Songs> allboxsong, child) {
                  List<Songs> allDbSongs = allboxsong.values.toList();
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
                      top: 10,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Songs songs = allDbSongs[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        child: ListTile(
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
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            songs.songname,
                            overflow: TextOverflow.ellipsis,
                            style: songnametext,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Playlists? plsongs =
                                  playlistsbox.getAt(widget.playlistIndex);
                              List<Songs> plnewsongs = plsongs!.playlistsongs;
                              isAlreadyAdded = plnewsongs.any(
                                  (element) => element.id == song[index].id);
                              if (!isAlreadyAdded) {
                                setState(() {
                                  playbuttonvisible = true;
                                });
                                plnewsongs.add(
                                  Songs(
                                    songname: song[index].songname,
                                    artist: song[index].artist,
                                    duration: song[index].duration,
                                    songurl: song[index].songurl,
                                    id: song[index].id,
                                    count: song[index].count
                                  ),
                                );
                                setState(() {
                                });
                                playlistsbox.putAt(
                                  widget.playlistIndex,
                                  Playlists(
                                      playlistname: psongs[widget.playlistIndex]
                                          .playlistname,
                                      playlistsongs: plnewsongs),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.black,
                                    duration: const Duration(seconds: 1),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    content: Text(
                                      '${song[index].songname}Added to ${psongs[widget.playlistIndex].playlistname}',
                                      style: songnametext,
                                    ),
                                  ),
                                );
                              } else {
                                setState(() {});

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.black,
                                        duration: const Duration(seconds: 1),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        content: Text(
                                          '${song[index].songname} is already added',
                                          style: songnametext,
                                        )));
                              }
                            },
                            icon: const Icon(
                              Icons.add_box_outlined,
                            ),
                            color: Colors.white,
                            splashRadius: 18,
                          ),
                        ),
                      );
                    },
                    itemCount: allDbSongs.length,
                  );
                },
              )),
            ])));
  }
}
