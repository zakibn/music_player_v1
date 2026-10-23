import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import '../data/datasource/static/stream_data.dart';
import '../data/model/music_track.dart';

class PlayerController extends GetxController {
  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Reactive player information
  final Rx<Duration> duration = Duration.zero.obs;
  final Rx<Duration> position = Duration.zero.obs;

  final RxInt currentStreamIndex = 0.obs;
  final Rx<PlayerState> playState = PlayerState.stopped.obs;

  // Music list
  late final RxList<MusicTrack> streams;

  // Event subscriptions
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _stateSubscription;
  StreamSubscription<void>? _completionSubscription;

  // Current music
  MusicTrack? get currentStream {
    if (streams.isEmpty) return null;
    return streams[currentStreamIndex.value];
  }

  @override
  void onInit() {
    super.onInit();

    // Load music list without another Controller
    streams = StreamData.data.obs;

    _durationSubscription = _audioPlayer.onDurationChanged.listen((value) {
      duration.value = value;
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((value) {
      position.value = value;
    });

    _stateSubscription = _audioPlayer.onPlayerStateChanged.listen((value) {
      playState.value = value;
    });

    _completionSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      position.value = duration.value;
    });
  }

  // Play or pause
  Future<void> smartPlay() async {
    if (playState.value == PlayerState.playing) {
      await pause();
    } else {
      await resume();
    }
  }

  // Play current song from the beginning
  Future<void> play() async {
    if (streams.isEmpty) return;

    await _audioPlayer.stop();
    position.value = Duration.zero;

    await resume();
  }

  // Resume playback
  Future<void> resume() async {
    if (streams.isEmpty) return;

    final music = streams[currentStreamIndex.value].music;

    if (music == null || music.isEmpty) return;

    await _audioPlayer.play(UrlSource(music));
  }

  // Pause
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  // Stop
  Future<void> stop() async {
    await _audioPlayer.stop();
    position.value = Duration.zero;
  }

  // Next song
  Future<void> next() async {
    if (streams.isEmpty) return;

    if (currentStreamIndex.value < streams.length - 1) {
      currentStreamIndex.value++;
    } else {
      currentStreamIndex.value = 0;
    }

    await play();
  }

  // Previous song
  Future<void> back() async {
    if (streams.isEmpty) return;

    if (currentStreamIndex.value > 0) {
      currentStreamIndex.value--;
    } else {
      currentStreamIndex.value = streams.length - 1;
    }

    await play();
  }

  // Change playback position
  Future<void> setPositionValue(double value) async {
    await _audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  @override
  void onClose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _stateSubscription?.cancel();
    _completionSubscription?.cancel();

    _audioPlayer.dispose();

    super.onClose();
  }
}
