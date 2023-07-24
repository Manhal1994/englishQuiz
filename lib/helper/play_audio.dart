import 'package:audioplayers/audioplayers.dart';

var audioPlayer = AudioPlayer();

playAudio(bool correct) {
  if (correct) {
    audioPlayer.play(AssetSource("audio/correct_answer.wav"));
  } else {
    audioPlayer.play(AssetSource("audio/wrong_answer.wav"));
  }
}
