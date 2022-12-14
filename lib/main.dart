import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/Screens/Playlist_Page/playlists_page.dart';
import 'package:music_player/db/Model/model.dart';
import 'package:music_player/db/functions/db_functions.dart';
import 'package:music_player/Screens/Home_Page/home.dart';
import 'package:music_player/Screens/Home_Page/homescreen.dart';
import 'package:music_player/Screens/Splash_Page/splash.dart';
import 'package:flutter/services.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox<Songs>('Songs');

  Hive.registerAdapter(FavsongsAdapter());
  await Hive.openBox<Favsongs>('favsongs');

  Hive.registerAdapter(PlaylistsAdapter());
  await Hive.openBox<Playlists>('playlists');

  Hive.registerAdapter(RecentSongsAdapter());
  await Hive.openBox<RecentSongs>('recentsongs');

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AppLogo(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.black),
        switchTheme: SwitchThemeData(trackColor: MaterialStateProperty.all(Colors.blue)),
        sliderTheme: const SliderThemeData(activeTrackColor: Colors.blue,inactiveTrackColor: Color.fromARGB(255,30,31,31),),
        primarySwatch: MaterialColor(0xFF880E4F,color,),
        tabBarTheme: const TabBarTheme(
        )
      ),
      routes: {
    '/homescreen': (context) => const HomeScreen(),
    '/playlists' :(context) =>  const PlaylistsPage(),
    '/playlists2' :(context) =>  const PlaylistsPage(),
  },
    );
  }
}

Map<int, Color> color =
{
50:Colors.transparent,
100:Colors.transparent,
200:Colors.transparent,
300:Colors.transparent,
400:Colors.transparent,
500:Colors.transparent,
600:Colors.transparent,
700:Colors.transparent,
800:Colors.transparent,
900:Colors.transparent,
};
