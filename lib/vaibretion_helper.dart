import 'dart:developer';

import 'package:cotec/core/assets_audio_player_compat.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class VibrationHelper {
  static orderSuccessVibrate() async {
    bool? customSupport = await Vibration.hasCustomVibrationsSupport();
    log('Custom Vibration Support: $customSupport');
    if (customSupport == true) {
      Vibration.vibrate(pattern: [100, 100, 0, 100]);
    } else {
      Vibration.vibrate();
    }
  }

  static cancelVibrate() async {
    Vibration.cancel();
  }

  static likeDislikeVibrate() async {
    bool? customSupport = await Vibration.hasCustomVibrationsSupport();
    if (customSupport == false) {
      Vibration.vibrate(duration: 20, amplitude: 128);
    } else {}
    SystemSound.play(SystemSoundType.click);
  }
}

class LocalAudioPlayer {
  static Future<void> play(String audioFile) async {
    await AssetsAudioPlayer.newPlayer().open(Audio(audioFile), volume: 0.7);
  }

  static void disposes() async {
    await AssetsAudioPlayer.newPlayer().stop();
    await AssetsAudioPlayer.newPlayer().dispose();
  }
}class LocalAudioPlayer2 {
  static Future<void> play(String audioFile) async {
    await AssetsAudioPlayer.newPlayer().open(Audio(audioFile), volume: 0.7);
  }

  static void disposes() async {
    await AssetsAudioPlayer.newPlayer().stop();
    await AssetsAudioPlayer.newPlayer().dispose();
  }
}
