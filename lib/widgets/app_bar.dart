import 'package:flutter/material.dart';
import 'package:music_player/Screens/Playlist_Page/playlists.dart';
import 'package:music_player/Screens/Search_Page/searchbar.dart';
import 'package:music_player/widgets/showdialogue_widget.dart';

AppBar appBarWidget(BuildContext context,
    {IconData? iconButton1, iconButton2}) {
  return AppBar(
    elevation: 0,
    flexibleSpace: Container(
      margin: const EdgeInsets.only(right: 250, top: 40),
      child: const Image(
        image: AssetImage('assets/images/Logo2.png'),
        height: 30,
      ),
    ),
    backgroundColor: Colors.black,
    actions: [
      IconButton(
        onPressed: () {
          showdialogue(context,plylists: playlistslist);
        },
        icon: Icon(
          iconButton1,
          size: 30,
          color: Colors.white,
        ),
        splashRadius: 18,
      ),
      IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchBar()));
        },
        icon: Icon(
          iconButton2,
          size: 30,
        ),
        splashRadius: 18,
      ),
    ],
  );
}
