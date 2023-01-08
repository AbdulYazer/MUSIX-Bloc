import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/Application/FavoritesBloc/favorites_bloc.dart';
import 'package:music_player/Screens/Home_Page/homescreen.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:music_player/style/style.dart';
import 'package:music_player/widgets/favorite_function.dart';
import 'package:music_player/widgets/heightbox_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../Application/HomeScreenBloc/home_screen_bloc.dart';
import '../../Application/RecentlyPlayedBloc/recently_played_bloc.dart';
import '../../Settings_Page/settings.dart';
import '../Currently_Playing_Page/currentlyplaying.dart';
import '../../db/Model/model.dart';
import '../../db/functions/db_functions.dart';

class SearchBar extends StatelessWidget {
   SearchBar({super.key});

  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer.withId('0');

  // void updateList(String value) {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //  BlocProvider.of<HomeScreenBloc>(context).add(const ClearSongs());
      _searchTextController.clear();
    });
   
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
        padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Search for Songs',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
            heightbox(height: 10),
            
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              child: Center(
                
                child:  TextField(
                  controller: _searchTextController,
                      onChanged: (value) {
                        BlocProvider.of<HomeScreenBloc>(context)
                            .add(UpdateValues(value: value));
                        // updateList(value);
                        // BlocProvider.of<HomeScreenBloc>(context)
                        //     .add(const );
                        // BlocProvider.of<HomeScreenBloc>(context)
                        //     .add(HomeScreenEvent.started());
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          hintText: 'What do you want to listen to?'),
                    
                ),
              ),
            ),
            BlocBuilder<HomeScreenBloc, HomeScreenState>(
              builder: (context, state) {
                searchresults = List.from(state.searchsongs);
                // BlocProvider.of<HomeScreenBloc>(context).add(const Search());
                return Expanded(
                  child: (searchresults.isEmpty)
                      ? const Center(
                          child: Text(
                            'No songs found',
                            style: songnametext,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            RecentSongs recents;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                  leading: QueryArtworkWidget(
                                    artworkBorder: BorderRadius.circular(15),
                                    artworkHeight: 90,
                                    artworkWidth: 60,
                                    id: searchresults[index].id,
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
                                    searchresults[index].songname,
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: songnametext,
                                  ),
                                  onTap: () {
                                    BlocProvider.of<HomeScreenBloc>(context)
                                        .add(const PlayerVisible());
                                    // setState(() {
                                    //   currentlyplayingvisibility = true;
                                    // });
                                    //print(searchresults[index].songname);
                                    recents = RecentSongs(
                                        songname: searchresults[index].songname,
                                        artist: searchresults[index].artist,
                                        duration: searchresults[index].duration,
                                        songurl: searchresults[index].songurl,
                                        id: searchresults[index].id,
                                        count: 0);
                                    updateRecentlyPlayed(recents);
                                    BlocProvider.of<RecentlyPlayedBloc>(context)
                                        .add(const Recently());
                                    final songIndex = allDbSongs.indexWhere(
                                        (e) =>
                                            e.songname.toString() ==
                                            searchresults[index]
                                                .songname
                                                .toString());
                                    songCount(allDbSongs[songIndex], songIndex);
                                    // setState(() {
                                    //   currentlyplayingvisibility = true;
                                    // });
                                    BlocProvider.of<HomeScreenBloc>(context)
                                        .add(const PlayerVisible());
                                    _audioPlayer.open(
                                      Playlist(
                                        audios: allSongs,
                                        startIndex: dbSongs.indexWhere(
                                            (element) =>
                                                element.songname ==
                                                searchresults[index].songname),
                                      ),
                                      showNotification: notificationSwitch,
                                    );
                                    // BlocProvider.of<HomeScreenBloc>(context).add(ClearSongs());
                                    _searchTextController.clear();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return CurrentlyPlaying(
                                          audioPlayer: audioPlayer);
                                    }));
                                  }),
                            );
                          },
                          itemCount: searchresults.length,
                        ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

Box<Songs> allboxsong = box;
List<Songs> allDbSongs = allboxsong.values.toList();
List<Songs> searchresults = List.from(allDbSongs);
TextEditingController _searchTextController = TextEditingController();
