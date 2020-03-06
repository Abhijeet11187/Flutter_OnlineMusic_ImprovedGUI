import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_online/downloadSong.dart';
import 'package:music_online/downloadURL.dart';
import 'package:music_online/main.dart';
import 'package:music_online/songList.dart';

class Playsong extends StatefulWidget {
  var songName;
  Playsong(this.songName);
  @override
  _PlaysongState createState() => _PlaysongState();
}

class _PlaysongState extends State<Playsong> {
  //  Variables
  var _imageAsset = 'images/waiting_gif.gif';
  String _songUrl;
  Duration _currentPosition;
  AudioCache audiocache;
  Duration _duration = Duration();
  Duration _position = Duration();
  AudioPlayer audioPlayer = new AudioPlayer();

  // Initiate song
  @override
  void initState() {
    _getMusic();
    // audioPlayer.play(_songUrl);
    super.initState();
  }

//Downloading Music

  _getMusic() async {
    return await DownloadSong.loadSongFromFirebase(context, widget.songName)
        .then((value) => {
              audioPlayer.play(value),
              audiocache = AudioCache(fixedPlayer: audioPlayer),
              audioPlayer.durationHandler = (d) => setState(() => {
                    _duration = d,
                  }),
              // audioPlayer.setNotification(),
              audioPlayer.positionHandler = (p) => setState(() => {
                    _position = p,
                  }),
              audioPlayer.onAudioPositionChanged.listen((Duration p) {
                setState(() {
                  _currentPosition = p;
                });
              }),
              setState(() {
                _songUrl = value;
                _imageAsset = 'images/musicplayingGif.gif';
              }),
              print("Song is Loaded  $value")
            });
  }

//  Return Song List

Widget returnSongList(){
  return Container(
    child: ListView.builder(
      itemCount: SongList().returnLength(),
      itemBuilder: (context,index){
       return Card(
          color: Colors.orangeAccent,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            onTap: () {
             audioPlayer.release();
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
    }),
  );
}
  // Seek Postion
  void seekToPosition(int seconds) {
    Duration newDuration = Duration(seconds: seconds);
    audioPlayer.seek(newDuration);
  }


  // Music Play , stop , forward , seek functionality widget

  Widget _music_Playing() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(widget.songName),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.03,
                child: Slider(
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    activeColor: Colors.greenAccent,
                    inactiveColor: Colors.black,
                    value: _position.inSeconds.toDouble(),
                    onChanged: (updatedValue) {
                      setState(() {
                        seekToPosition(updatedValue.toInt());
                        //  value=updatedValue;
                      });
                    }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  tooltip: 'Reverse Song',
                  icon: Icon(Icons.replay_10),
                  onPressed: () async {
                    //Subtract 10 sec extra to current postion of song and pass to seek method
                    Duration _seekPosition =
                        _currentPosition - Duration(milliseconds: 1000);
                    await audioPlayer.seek(_seekPosition);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.stop),
                  tooltip: 'Stop',
                  onPressed: () async {
                    await audioPlayer.stop();
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  tooltip: 'Pause',
                  icon: Icon(Icons.pause),
                  onPressed: () async {
                    await audioPlayer.pause();
                    setState(() {
                      _imageAsset = 'images/waiting_gif.gif';
                    });
                  },
                ),
                IconButton(
                  tooltip: 'Resume',
                  icon: Icon(Icons.play_arrow),
                  onPressed: () async {
                    await audioPlayer.resume();
                    setState(() {
                      _imageAsset = 'images/musicplayingGif.gif';
                    });
                  },
                ),
                IconButton(
                  tooltip: 'Forward Song',
                  icon: Icon(Icons.forward_10),
                  onPressed: () async {
                    Duration _seekPosition =
                        _currentPosition + Duration(milliseconds: 1000);
                    await audioPlayer.seek(_seekPosition);
                  },
                ),
                IconButton(
                  tooltip: 'Download Song',
                  icon: Icon(Icons.file_download),
                  onPressed: () {
                    DownloadSongtoPhone()
                        .downloadSong(context, _songUrl, widget.songName);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Sliver AppBar Contents

  Widget showSliverAppBar() {
    return Column(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width,
            child: Center(child: Image.asset(_imageAsset))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_music_Playing()],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          iconTheme: IconThemeData(
               color: Colors.black
          ),
          pinned: true,
          backgroundColor: Colors.white,
          expandedHeight: MediaQuery.of(context).size.height * 0.50,
          flexibleSpace: FlexibleSpaceBar(
            background: SingleChildScrollView(child: showSliverAppBar()),
          ),
        ),
        SliverFillRemaining(
          child: returnSongList(),
        )
      ],
    ));
  }
}
