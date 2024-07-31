import 'dart:async';

import 'package:radio_player/radio_player.dart';

class RadioClass {

  final RadioPlayer radioPlayer = RadioPlayer();
  bool isPlaying = false;

  Future<void> setChannel(String name, String url) async {
    radioPlayer.stop();

    await radioPlayer.setChannel(
      title: name,
      url: url,
    );
  }

  void play() {
    radioPlayer.play();
  }

  void pause() {
    radioPlayer.pause();
  }

  void stop()  {
    radioPlayer.stop();
  }

}