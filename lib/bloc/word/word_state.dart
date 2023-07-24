part of 'word_bloc.dart';

@immutable
abstract class WordState {}

class WordInitial extends WordState {}

class WordSelected extends WordState {
  final OptionPosition optionPosition;
  WordSelected(this.optionPosition);
}

