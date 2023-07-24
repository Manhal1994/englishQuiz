part of 'quiz_bloc.dart';

@immutable
abstract class QuizEvent {}

class QuizFetchEvent extends QuizEvent {
  QuizFetchEvent();
}
