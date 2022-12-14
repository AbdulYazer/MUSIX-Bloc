import 'package:flutter/material.dart';
import 'package:music_player/Screens/Favourites_page/Favorite/favourite_songs.dart';
import 'package:music_player/Screens/Favourites_page/Mostly_Played_Page/mostly_played_songs.dart';
import 'package:music_player/Screens/Favourites_page/RecentlyPlayed/Recently_played_songs.dart';
import 'package:music_player/Screens/Search_Page/searchbar.dart';
import 'package:music_player/style/style.dart';
import '../../widgets/heightbox_widget.dart';

class Favourites extends StatefulWidget {
   const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}
class _FavouritesState extends State<Favourites> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        backgroundColor: bgcolor,
        appBar: appBar(context),
        body: Column(
          children: const [
            Expanded(
              child: TabBarView(
                children: [
                  FavoriteSongs(),
                  RecentlyPlayed(),
                  MostlyPlayedScreen(),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


PreferredSize appBar(BuildContext context){
  return PreferredSize(
    preferredSize:const Size.fromHeight(130.0),
    child: AppBar(
      elevation: 0,
            flexibleSpace:Container(
              margin:const EdgeInsets.only(right: 250,top: 40),
              child: const Image(image: AssetImage('assets/images/Logo2.png'),height: 30,)),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const SearchBar()));
                }, 
                icon:const Icon(Icons.search_outlined,size: 30,))
              ],
              bottom: TabBar(
                labelPadding: const EdgeInsets.symmetric(vertical: 8),
                unselectedLabelColor: Colors.amber,
                indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Creates border
                color:const  Color.fromARGB(255, 66, 77, 95)),
                isScrollable: true,
                indicatorColor: Colors.transparent,
                
                tabs: [
                  tabs(
                    icon: Icons.favorite,
                    color: tab1Color, 
                    text: 'Favorites',
                  ),
                   tabs(
                    icon: Icons.schedule,
                    color: tab2color, 
                    text: 'Recently Played',
                  ),
                   tabs(
                    icon: Icons.library_music,
                    color: tab3color, 
                    text: 'Mostly Played',
                  )],),
    ),
  );
}

Tab tabs({required Color color,required String text,required IconData icon}){
  return Tab(
    child: ClipRRect(
      child: SizedBox(
        width: 180,
        child: Column(
          children: [
            heightbox(height: 5),
            Icon(icon,color: color,size: 20,),
            heightbox(height: 5),
            Text(text,style: tabnames),
          ],
        ),
      ),
    ),
  );
}

