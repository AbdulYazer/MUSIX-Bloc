import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/Application/BottomNavBloc/bottom_nav_bloc.dart';
import 'package:music_player/Screens/Favourites_page/favourites_page.dart';
import 'package:music_player/Screens/Home_Page/homescreen.dart';
import 'package:music_player/Screens/Playlist_Page/playlists_page.dart';
import 'package:music_player/Settings_Page/settings.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(),
      Favourites(),
      PlaylistsPage(),
      Settings(),
    ];
    return BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
    return Scaffold(
      body: screens[state.index],
      bottomNavigationBar: 
         BottomNavigationBar(
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(179, 188, 185, 185),
            backgroundColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            currentIndex: state.index,
            items: const [
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
            onTap: (index) {
            BlocProvider.of<BottomNavBloc>(context).add(IndexChanger(index: index));
            },
          )
       
    );
  });
}
}