import 'package:flutter/material.dart';
import 'package:music_player/Screens/Favourites_page/Favorite/favourite_songs.dart';
import '../../../db/Model/model.dart';
import '../../../db/functions/db_functions.dart';

class FavIcon extends StatefulWidget {
  FavIcon({super.key, required this.index});
  int index;

  @override
  State<FavIcon> createState() => _FavIconState();
}

class _FavIconState extends State<FavIcon> {
  bool favorited = false;
  List<Favsongs> fav = [];
  final box = SongBox.getInstance();
  late List<Songs> dbSongs;
  @override
  void initState() {
    dbSongs = box.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fav = favdbsongs.values.toList();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        fav
          .where((element) =>
              element.id == dbSongs[widget.index].id.toString())
                .isEmpty
            ? IconButton(
                onPressed: () {
                  // print(dbSongs[widget.index].songname);
                  // print(dbSongs[widget.index].id);
                  favdbsongs.add(
                    Favsongs(
                      artist: dbSongs[widget.index].artist,
                      duration: dbSongs[widget.index].duration.toString(),
                      songname: dbSongs[widget.index].songname,
                      songurl: dbSongs[widget.index].songurl,
                      id: dbSongs[widget.index].id.toString(),
                      //index: widget.index,
                    ),
                  );

                  setState(() {});
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
                        '${dbSongs[widget.index].songname}Added to favourites',
                      ),
                    ),
                  );
                  //addfavfromdb();
                  // print(dbSongs[widget.index].songname);
                  // print(favdbsongs.values.toList());
                },
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
                splashRadius: 15,
              )
            : IconButton(
                onPressed: () async {
                  int currentIndex = fav.indexWhere((element) =>
                      element.songname == dbSongs[widget.index].songname);
                  await favdbsongs.deleteAt(currentIndex);
                  // print(currentIndex);
                  setState(() {});

                  // ignore: use_build_context_synchronously
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
                          '${dbSongs[widget.index].songname} Removed from favourites'),
                    ),
                  );
                  // addfavfromdb();

                  // print(widget.index);
                },
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                splashRadius: 15,
              ),
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 20),
        //   child: HomePlaylistButton(
        //     songindex: widget.index,
        //   ),
        // )
      ],
    );
  }
}
