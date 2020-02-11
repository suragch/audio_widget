import 'package:flutter/foundation.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioViewModel extends ChangeNotifier {
  static AudioCache audioCache = AudioCache();
  AudioPlayer player;

  bool _isPlaying = false;
  Duration _currentTime = Duration();
  Duration _totalTime = Duration(milliseconds: 1);

  bool get isPlaying => _isPlaying;
  Duration get currentTime => _currentTime;
  Duration get totalTime => _totalTime;

  Future loadData() async {
    player = await audioCache.play('demo.mp3');

    var stream;
    stream = player.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      _totalTime = d;
      stream.cancel();
      notifyListeners();
    });
    await player.pause();
    player.onAudioPositionChanged.listen((Duration p) {
      print(p);
      _currentTime = p;
      notifyListeners();
    });
    player.onPlayerStateChanged.listen((AudioPlayerState s) {
      if (s == AudioPlayerState.COMPLETED) {
        print('reached end');
        _isPlaying = false;
        _currentTime = Duration();
        notifyListeners();
      }
    });
  }

  void play() async {
    await player.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await player.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void seek(Duration position) async {
    await player.seek(position);
  }
}
