import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/Application/PlaylistsBloc/playlists_bloc.dart';
import 'package:music_player/db/Model/model.dart';
import 'package:music_player/style/style.dart';
import 'package:music_player/widgets/heightbox_widget.dart';

import '../db/functions/db_functions.dart';

TextEditingController textController = TextEditingController();
  final formkey = GlobalKey<FormState>();

Future showdialogue(BuildContext context, {required List<Songs> plylists}) {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    heightbox(height: 10),
                    const Text(
                      'Playlist name',
                      style: showdialogtext1,
                    ),
                    heightbox(height: 10),
                    const Text(
                      'Enter playlist name',
                      style: showdialogtext2,
                    ),
                    heightbox(height: 20),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 222, 218, 218),
                          borderRadius: BorderRadius.circular(10)),
                      child: Form(
                        key: formkey,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: InputBorder.none),
                          controller: textController,
                          validator: (value) {
                            List<Playlists> values = playlistsbox.values.toList();
                      
                            bool isAlreadyAdded = values
                                .where((element) =>
                                    element.playlistname == value!.trim())
                                .isNotEmpty;
                      
                            if (value!.trim() == '') {
                              return 'Name Required';
                            }
                            if (isAlreadyAdded) {
                              return 'This Name Already Exist';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    heightbox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 222, 218, 218),
                              borderRadius: BorderRadius.circular(50)),
                          height: 40,
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              textController.clear();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 222, 218, 218),
                              borderRadius: BorderRadius.circular(50)),
                          height: 40,
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              // if (textController.text.trim().isEmpty) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       backgroundColor: Colors.white,
                              //       duration: const Duration(seconds: 1),
                              //       margin: const EdgeInsets.symmetric(
                              //           horizontal: 10, vertical: 10),
                              //       behavior: SnackBarBehavior.floating,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius:
                              //               BorderRadius.circular(10)),
                              //       content: const Text('Enter Valid Name',style: TextStyle(color: Colors.black),),
                              //     ),
                              //   );
                              // }
                              if(formkey.currentState!.validate()){
                              playlistsbox.add(Playlists(
                                  playlistname: textController.text,
                                  playlistsongs: []));
                              Navigator.pop(context);
                              }
                              textController.clear();
                              BlocProvider.of<PlaylistsBloc>(context).add(const PlaylistsAdded());
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ));
}
