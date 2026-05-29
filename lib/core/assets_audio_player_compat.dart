import 'package:audioplayers/audioplayers.dart' as ap;

class Audio {
  final String path;
  Audio(this.path);
}

class AssetsAudioPlayer {
  final ap.AudioPlayer _player = ap.AudioPlayer();

  AssetsAudioPlayer();
  
  static AssetsAudioPlayer newPlayer() => AssetsAudioPlayer();

  Future<void> open(Audio audio, {double volume = 1.0}) async {
    var assetPath = audio.path;
    if (assetPath.startsWith('assets/')) {
      assetPath = assetPath.substring(7); // Remove 'assets/' prefix
    }
    
    try {
      await _player.setVolume(volume);
      await _player.play(ap.AssetSource(assetPath));
    } catch (e) {
      // Ignore or log error
      print("AssetsAudioPlayer compatibility wrapper error playing sound: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      // Ignore
    }
  }

  Future<void> dispose() async {
    try {
      await _player.dispose();
    } catch (e) {
      // Ignore
    }
  }
}
