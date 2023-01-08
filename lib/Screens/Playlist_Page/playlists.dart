import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/Application/HomeScreenBloc/home_screen_bloc.dart';
import 'package:music_player/Screens/Playlist_Page/Adding_Songs_Playlist.dart';
import 'package:music_player/Screens/Playlist_Page/play&pause_button.dart';
import 'package:music_player/Screens/Playlist_Page/playlists_page.dart';
import 'package:music_player/Screens/Currently_Playing_Page/currentlyplaying.dart';
import 'package:music_player/db/functions/db_functions.dart';
import 'package:music_player/Screens/Search_Page/searchbar.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:music_player/style/style.dart';
import 'package:music_player/widgets/heightbox_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../Application/PlaylistsBloc/playlists_bloc.dart';
import '../../Settings_Page/settings.dart';
import '../../db/Model/model.dart';

List<Songs> songs = [];
List<Songs> playlistslist = [];
List<Audio> playlistsongs = [];
AssetsAudioPlayer audioPlayerplaylist = AssetsAudioPlayer.withId('0');

class PlaylistsSongs extends StatelessWidget {
  PlaylistsSongs(
      {super.key,
      required this.playlistname,
      required this.playlistindex,
      required this.allplaylistsongs});
  String playlistname;
  int playlistindex;
  List<Songs> allplaylistsongs = [];

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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Addplaylistsfromdb(allplaylistsongs: allplaylistsongs);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddingSongsPlaylist(
                            playlistIndex: playlistindex,
                          )));
                  BlocProvider.of<PlaylistsBloc>(context)
                      .add(const PlaylistsAdded());
                },
                icon: const Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                ),
              ),
              Popupbutton(
                playlistindex: playlistindex,
                playlistlist: playlistslist,
              ),
            ],
          ),
          playlisticon(context),
          heightbox(height: 20),
          // ValueListenableBuilder<Box<Playlists>>(valueListenable: playlistsbox.listenable(),
          //  builder: (context, value, child){
          BlocBuilder<PlaylistsBloc, PlaylistsState>(
            builder: (context, state) {
              return Text(
                state.playlistdb.toList()[playlistindex].playlistname,
                style: playlistnametext,
              );
            },
          ),
          //  }),

          heightbox(height: 20),
          PlayPauseButton(
              playlistname: playlistname,
              playlistindex: playlistindex,
              allplaylistsongs: allplaylistsongs),
          heightbox(height: 10),
          Expanded(child: BlocBuilder<PlaylistsBloc, PlaylistsState>(
            builder: (context, state) {
              final playlistsong = state.playlistdb.toList();
              songs = playlistsong[playlistindex].playlistsongs;
              Addplaylistsfromdb(allplaylistsongs: allplaylistsongs);
              RecentSongs recents;
              if (songs.isEmpty) {
                return Builder(builder: (context) {
                  playbuttonvisible = false;
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //addsongbutton(context),
                        heightbox(height: 120),
                        //TextButton(onPressed: (){}, child: const Text('Add Songs',style: TextStyle(color: Colors.white,fontSize: 18),)),
                        const Text(
                          'No Songs Added !',
                          style: songnametext,
                        ),
                      ],
                    ),
                  );
                });
              }

              return ListView.builder(
                  //itemExtent: 80,
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        BlocProvider.of<HomeScreenBloc>(context)
                            .add(const PlayerVisible());
                        recents = RecentSongs(
                            songname: songs[index].songname,
                            artist: songs[index].artist,
                            id: songs[index].id,
                            duration: songs[index].duration,
                            songurl: songs[index].songurl,
                            count: 0);
                        updateRecentlyPlayed(recents);
                        final songIndex = allDbSongs.indexWhere((e) =>
                            e.songname.toString() ==
                            songs[index].songname.toString());
                        songCount(allDbSongs[songIndex], songIndex);
                        audioPlayerplaylist.open(
                          Playlist(audios: playlistsongs, startIndex: index),
                          showNotification: notificationSwitch,
                        );
                        isPlaying = true;
                        BlocProvider.of<PlaylistsBloc>(context)
                            .add(const PlaylistsAdded());

                        // setState(() {
                        //   //playerVisibility= true;
                        // });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => CurrentlyPlaying(
                                    audioPlayer: audioPlayerplaylist,
                                  )),
                        );
                        //print(playlistsongs);
                      },
                      leading: QueryArtworkWidget(
                        id: songs[index].id,
                        type: ArtworkType.AUDIO,
                        artworkHeight: 90,
                        artworkWidth: 60,
                        artworkBorder: BorderRadius.circular(15),
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
                        songs[index].songname,
                        style: songnametext,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        songs[index].artist,
                        style: singernametext,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            songs.removeAt(index);
                            playlistsbox.putAt(
                              playlistindex,
                              Playlists(
                                  playlistname: playlistname,
                                  playlistsongs: songs),
                            );
                            Addplaylistsfromdb(
                                allplaylistsongs: allplaylistsongs);
                            BlocProvider.of<PlaylistsBloc>(context)
                                .add(const PlaylistsAdded());

                            //     ScaffoldMessenger.of(context).showSnackBar(
                            // SnackBar(
                            //   backgroundColor: Colors.white,
                            //   duration: const Duration(seconds: 1),
                            //   margin: const EdgeInsets.symmetric(
                            //       horizontal: 10, vertical: 10),
                            //   behavior: SnackBarBehavior.floating,
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10)),
                            //   content: Text(
                            //       '${playlistsongs[index].metas.title} Removed from ${widget.playlistname}',style: const TextStyle(color: Colors.black),),
                            // ),
                            // );
                          },
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          )),
                    );
                  });
            },
          )
              //   },
              // ),
              ),
        ],
      ),
    );
  }
}

Widget playlisticon(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const Image(
                image: AssetImage(
                  'assets/images/playlists.png',
                ),
                fit: BoxFit.cover,
              ))),
    ],
  );
}

class Popupbutton extends StatelessWidget {
  Popupbutton(
      {super.key, required this.playlistindex, required this.playlistlist});
  int playlistindex;
  List<Songs> playlistlist;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Color.fromARGB(255, 255, 255, 255),
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      itemBuilder: (item) => <PopupMenuItem<int>>[
        const PopupMenuItem(
          value: 0,
          child: SizedBox(
            width: 80,
            child: Text(
              'Rename',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
        // const PopupMenuItem(
        //   value: 1,
        //   child: SizedBox(
        //     width: 80,
        //     child: Text(
        //       'Delete',
        //       style: TextStyle(color: Colors.black, fontSize: 15),
        //     ),
        //   ),
        // )
      ],
      onSelected: (selectedindex) async {
        switch (selectedindex) {
          case 0:
            showdialogue1(context, textController, playlistindex,
                playlistlist);
            break;
          // case 1:
          //   showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //         backgroundColor: Colors.white,
          //         content: const Text(
          //           'Do you want to delete ?',
          //           style: TextStyle(color: Colors.black, fontSize: 15),
          //         ),
          //         actions: [
          //           TextButton(
          //             onPressed: () {
          //               playlistsbox.deleteAt(widget.playlistindex);
          //               // Navigator.of(context).popUntil((ModalRoute.withName('/playlists')));
          //               Navigator.of(context).pop();
          //               Navigator.of(context).pop();

          //             },
          //             child: const Text(
          //               'Yes',
          //               style: TextStyle(color: Colors.black, fontSize: 15),
          //             ),
          //           ),
          //           TextButton(
          //             onPressed: () {
          //               Navigator.pop(context);
          //             },
          //             child: const Text('No',
          //                 style: TextStyle(color: Colors.black, fontSize: 15)),
          //           ),
          //         ],
          //       );
          //     },
          //   );
        }
      },
    );
  }
}

Addplaylistsfromdb({required List<Songs> allplaylistsongs}) {
  playlistsongs.clear();
  for (var item in allplaylistsongs) {
    playlistsongs.add(Audio.file(item.songurl,
        metas: Metas(
          title: item.songname,
          artist: item.artist,
          id: item.id.toString(),
        )));
  }
}
