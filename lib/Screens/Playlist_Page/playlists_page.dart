import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/Screens/Playlist_Page/playlists.dart';
import 'package:music_player/widgets/app_bar.dart';
import 'package:music_player/style/style.dart';
import 'package:music_player/widgets/showdialogue_widget.dart';
import '../../Application/PlaylistsBloc/playlists_bloc.dart';
import '../../db/Model/model.dart';
import '../../db/functions/db_functions.dart';
import '../../widgets/heightbox_widget.dart';

TextEditingController textController = TextEditingController();

class PlaylistsPage extends StatelessWidget {
  PlaylistsPage({super.key});

  // List<Playlists> playlistslist = [];

  List<Songs> playlistsongs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgcolor,
        appBar: appBarWidget(
          context,
          iconButton1: Icons.add_box_outlined,
          iconButton2: Icons.search_outlined,
        ),
        body:
            // ValueListenableBuilder<Box<Playlists>>(
            //     valueListenable: Hive.box<Playlists>('playlists').listenable(),
            //     builder: (context, Box<Playlists> playlistsdb, child) {

            BlocBuilder<PlaylistsBloc, PlaylistsState>(
          builder: (context, state) {
            final playlistslist = state.playlistdb.toList();
            if (playlistslist.isEmpty) {
              return const Center(
                child: Text(
                  'No Playlist!\nCreate one.',
                  style: songnametext,
                ),
              );
            }
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: playlistslist.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 1),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => PlaylistsSongs(
                                playlistindex: index,
                                playlistname: playlistslist[index].playlistname,
                                allplaylistsongs:
                                    playlistslist[index].playlistsongs,
                              )))),
                      child: playlists(context, index: index)),
                );
              },
            );
          },
        )
        // })
        );
  }

  Widget playlists(BuildContext context, {required int index}) {
    return BlocBuilder<PlaylistsBloc, PlaylistsState>(
      builder: (context, state) {
        final playlistslist = state.playlistdb.toList();
        return ListView(
          children: [
            Stack(
              children: [
                Container(
                    height: 93,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/playlists.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20))),
                Positioned(
                  right: -9,
                  top: -2,
                  child: Popupbutton1(
                    playlistindex: index,
                    playlistlist: playlistslist[index].playlistsongs,
                  ),
                )
              ],
            ),
            heightbox(height: 5),
            Center(
              child: Text(
                playlistslist[index].playlistname,
                style: playlistnametext1,
              ),
            ),
          ],
        );
      },
    );
  }
}

class Popupbutton1 extends StatelessWidget {
  Popupbutton1(
      {super.key, required this.playlistindex, required this.playlistlist});
  int playlistindex;
  List<Songs> playlistlist;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Color.fromARGB(255, 255, 255, 255),
      icon: const Icon(
        Icons.more_vert,
        color: Colors.black,
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
        const PopupMenuItem(
          value: 1,
          child: SizedBox(
            width: 80,
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        )
      ],
      onSelected: (selectedindex) async {
        switch (selectedindex) {
          case 0:
            showdialogue1(context, textController, playlistindex, playlistlist);
            break;
          case 1:
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: const Text(
                    'Do you want to delete ?',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        playlistsbox.deleteAt(playlistindex);
                        BlocProvider.of<PlaylistsBloc>(context).add(const PlaylistsAdded());
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No',
                          style: TextStyle(color: Colors.black, fontSize: 15)),
                    ),
                  ],
                );
              },
            );
        }
      },
    );
  }
}

Future showdialogue1(BuildContext context, TextEditingController textController,
    int index, List<Songs> playlistslist) {
  textController = TextEditingController(
      text: playlistsbox.values.toList()[index].playlistname);
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    heightbox(height: 10),
                    const Text(
                      'Edit Playlist name',
                      style: showdialogtext1,
                    ),
                    heightbox(height: 10),
                    // const Text(
                    //   'Enter playlist name',
                    //   style: showdialogtext2,
                    // ),
                    // heightbox(height: 20),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 222, 218, 218),
                          borderRadius: BorderRadius.circular(10)),
                      child: Form(
                        key: formkey,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: InputBorder.none),
                          controller: textController,
                          validator: (value) =>
                              (value!.trim().isEmpty) ? 'Name Required' : null,
                        ),
                      ),
                    ),
                    heightbox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 222, 218, 218),
                              borderRadius: BorderRadius.circular(50)),
                          height: 40,
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 222, 218, 218),
                              borderRadius: BorderRadius.circular(50)),
                          height: 40,
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              //List<Playlists> playlists = [];
                              if (textController.text.trim() ==
                                  playlistsbox.values
                                      .toList()[index]
                                      .playlistname) {
                                Navigator.pop(context);
                              } else if (formkey.currentState!.validate()) {
                                playlistsbox.putAt(
                                  index,
                                  Playlists(
                                      playlistname: textController.text,
                                      playlistsongs: playlistsbox.values
                                          .toList()[index]
                                          .playlistsongs),
                                );
                                Navigator.pop(context);
                                // Navigator.pop(context);

                              }
                              BlocProvider.of<PlaylistsBloc>(context).add(const PlaylistsAdded());
                              textController.clear();
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ));
}
