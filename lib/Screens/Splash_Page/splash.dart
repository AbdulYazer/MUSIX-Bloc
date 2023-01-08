import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/db/Model/model.dart';
import 'package:music_player/Screens/Home_Page/home.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../Favourites_page/RecentlyPlayed/Recently_played_songs.dart';
import '../../db/functions/db_functions.dart';

bool playbuttonvisible = false;
late bool status;

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  Timer goToHome(BuildContext context) {
    return Timer(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) => const Home()),
      ),
    );
  }

  void requestStoragePremission(BuildContext context) async {
    //Permission.storage.request();
    bool permissionStatus = await player.permissionsStatus();
    // status = permissionStatus;
    if (!permissionStatus) {
      await player.permissionsRequest();
       goToHome(context);
      fetchallSongs = await player.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
      );

      for (var element in fetchallSongs) {
        if (element.fileExtension == "mp3") {
          allsongs.add(element);
        }
      }

      for (var element in allsongs) {
        box.add(Songs(
            songname: element.title,
            artist: element.artist!,
            duration: element.duration!,
            songurl: element.uri!,
            id: element.id,
            count: 0
            ));
      }

      // for (var element in allSongs) {
      //   mostplayedsongs.add(MostPlayed(
      //       songname: element.title,
      //       songurl: element.uri!,
      //       duration: element.duration!,
      //       artist: element.artist!,
      //       count: 0,
      //       id: element.id),);
      // }
    }else{
      goToHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    requestStoragePremission(context);
    openfavdb();
    openplaylistsdb();
    openrecentdb();
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image(image: AssetImage('assets/images/Logo.png'),height: 170,width: 170,),
      ),
    );
  }
}
final player = OnAudioQuery();
final box = SongBox.getInstance();
final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

List<SongModel> fetchallSongs = [];
List<SongModel> allsongs = [];
List<Audio> songsList = [];