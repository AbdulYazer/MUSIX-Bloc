import 'package:flutter/material.dart';
import 'package:music_player/Screens/Favourites_page/favourites_page.dart';
import 'package:music_player/Screens/Home_Page/homescreen.dart';
import 'package:music_player/Screens/Playlist_Page/playlists_page.dart';
import 'package:music_player/Settings_Page/settings.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
   const screens =  [
    HomeScreen(),
    Favourites(),
    PlaylistsPage(),
    Settings(),
  ];
    return Scaffold(
      body: screens[_currentIndex], 
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor:const Color.fromARGB(179, 188, 185, 185),
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items:const [
           BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play_sharp),
            label: '',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}