import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_online/playSong.dart';
import 'package:music_online/songList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Online Music'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// Varaible Declaration

  
  SliverList getSilvers(context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, int index) {
      return Card(
        color: Colors.orangeAccent,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Playsong(SongList().returnSong(index))));
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Image.asset('images/imageIcon.gif')),
          ),
          title: Text(SongList().returnSong(index)),
        ),
      );
    },
    childCount:SongList().returnLength(),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height*0.43,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset('images/enjoyMusic_gif.gif',fit: BoxFit.cover,),
              ),
              pinned: false,
              // floating:false,
              backgroundColor: Colors.white,
            ),
            getSilvers(context),
          ],
        ));
  }
}
