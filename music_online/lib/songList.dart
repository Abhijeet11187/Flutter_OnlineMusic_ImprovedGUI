class SongList {
  List _songAll = [
    'Kadak_Ban_Emiway.mp3',
    'Hands UP.mp3',
    'Bol Hu.mp3',
    'Breathless Shankar Mahadevan.mp3',
    'Heeriye.mp3',
    'Chadhta Sooraj Dheere Dheere.mp3',
    'Jeena isika nam hai.mp3',
    'Malang title Track.mp3',
    'Nazar Nazar (Hathyar).mp3',
    'Hookah bar.mp3',
    'Mere Naam Tu.mp3',
    'Moh Ke Dhaage (Female).mp3',
    'Jigra Uri.mp3',
    'Moh Ke Dhaage (Male).mp3',
    'Tadbeer Se Bigdi Hui.mp3',
    'Namo_Namo_-_Kedarnath.mp3',
  ];

  String returnSong(index) {
    return _songAll[index];
  }

  int returnLength() {
    return _songAll.length;
  }
}
