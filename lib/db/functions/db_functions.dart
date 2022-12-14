import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import '../Model/model.dart';

late Box<Favsongs> favdbsongs;
late Box<Playlists> playlistsbox;


openfavdb() async {
  favdbsongs = await Hive.openBox<Favsongs>('favsongs');
  //favdbsongs.clear();
}
openplaylistsdb() async {
  playlistsbox = await Hive.openBox<Playlists>('playlists');
}

bool currentlyplayingvisibility = false;

late Box<RecentSongs> recentdbbox;

openrecentdb () async{
  recentdbbox = await Hive.openBox('RecentSongs');
  // recentdbbox.clear();
  
} 

updateRecentlyPlayed(RecentSongs value) {
  // recentlyplayedbox.clear();
  // mostplayedsongs.clear();
  List<RecentSongs> list = recentdbbox.values.toList();
  bool isAlready =
      list.where((element) => element.songname == value.songname).isNotEmpty;

  if (isAlready == false) {
    recentdbbox.add(value);
    

    // print(recentdbbox.values.toList());
  } else {
    
    int index =
        list.indexWhere((element) => element.songname == value.songname);
    recentdbbox.deleteAt(index);
    recentdbbox.add(value);
  }
}

songCount(Songs value, int index) {
  int count = value.count;
  value.count = count + 1;
  box.putAt(index, value);
  print("${value.songname} played  ${value.count} times");
}
