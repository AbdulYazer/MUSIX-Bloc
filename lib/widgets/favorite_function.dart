import 'package:flutter/material.dart';
import 'package:music_player/Screens/Favourites_page/Favorite/favourite_songs.dart';
import '../db/Model/model.dart';
import '../db/functions/db_functions.dart';


  List<Favsongs> fav = [];
  final box1 = SongBox.getInstance();
   List<Songs> dbSongs = box1.values.toList(); 
 

  addtofav(BuildContext context,{required int index}) {
    fav = favdbsongs.values.toList();
    if (fav
        .where((element) => element.songname == dbSongs[index].songname)
        .isEmpty) {
          favdbsongs.add(Favsongs(
          songname: dbSongs[index].songname,
          artist: dbSongs[index].artist,
          duration: dbSongs[index].duration.toString(),
          songurl: dbSongs[index].songurl,
          id: dbSongs[index].id.toString()));
      //setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Text(
            '${dbSongs[index].songname}Added to favourites',
          ),
        ),
      );
      //addfavfromdb();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Text(
            '${dbSongs[index].songname.split('-').first} is already added to favourites',
          ),
        ),
      );
    }
  }