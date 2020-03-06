import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DownloadSong{
  
  static Future<dynamic> loadSongFromFirebase(BuildContext context, String songName)async{
    return await FirebaseStorage.instance
        .ref()
        .child(songName)
        .getDownloadURL();
  }
}