import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/Screens/Favourites_page/Favorite/favourite_songs.dart';
import '../../../Application/FavoritesBloc/favorites_bloc.dart';
import '../../../Application/HomeScreenBloc/home_screen_bloc.dart';
import '../../../db/Model/model.dart';
import '../../../db/functions/db_functions.dart';

class FavIcon extends StatelessWidget {
  final List<Songs> dbSongs;
  FavIcon({super.key, required this.index, required this.dbSongs});
  int index;

  bool favorited = false;

  List<Favsongs> fav = [];

  final box = SongBox.getInstance();

  // final List<Songs> dbSongs = box.values.toList();

  @override
  Widget build(BuildContext context) {
    fav = favdbsongs.values.toList();
    // return BlocBuilder<FavoritesBloc, FavoritesState>(
        // builder: (context, state) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          fav
                  .where((element) =>
                      element.id == dbSongs[index].id.toString())
                  .isEmpty
              ? IconButton(
                  onPressed: () {
                    // print(dbSongs[widget.index].songname);
                    // print(dbSongs[widget.index].id);
                    favdbsongs.add(
                      Favsongs(
                        artist: dbSongs[index].artist,
                        duration:
                            dbSongs[index].duration.toString(),
                        songname: dbSongs[index].songname,
                        songurl: dbSongs[index].songurl,
                        id: dbSongs[index].id.toString(),
                        //index: widget.index,
                      ),
                    );
                    BlocProvider.of<FavoritesBloc>(context)
                        .add(const FavoritesEvent.started());

                    // setState(() {});
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
                          '${dbSongs[index].songname}Added to favourites',
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
                  onPressed: () {
                    int currentIndex = fav.indexWhere((element) =>
                        element.songname ==
                        dbSongs[index].songname);
                    favdbsongs.deleteAt(currentIndex);
                    BlocProvider.of<FavoritesBloc>(context)
                        .add(const FavoritesEvent.started());

                    // print(currentIndex);
                    // setState(() {});

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
                            '${dbSongs[index].songname} Removed from favourites'),
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
                )

          // Padding(
          //   padding: const EdgeInsets.only(bottom: 20),
          //   child: HomePlaylistButton(
          //     songindex: widget.index,
          //   ),
          // )
        ],
      );
    // });
  }
}
