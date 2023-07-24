part of 'word_bloc.dart';

@immutable
abstract class WordEvent {}

class ChooseWordEvent extends WordEvent{
  final OptionPosition optionPosition;
  final BuildContext context;
  ChooseWordEvent(this.optionPosition,this.context);

}
