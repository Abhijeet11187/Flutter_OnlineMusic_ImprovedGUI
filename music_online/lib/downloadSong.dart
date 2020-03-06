import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadSongtoPhone{
void downloadSong(BuildContext context,songURL,songName)async{
    Dio dio=Dio();
    var dir=await getExternalStorageDirectory();
    await dio.download(songURL, "${dir.path}/$songName.mp3");
}
}