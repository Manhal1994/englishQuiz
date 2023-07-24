part of 'quiz_bloc.dart';

@immutable
abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoaded extends QuizState {
  final List<QuestionModel> questions;
  QuizLoaded(this.questions);
}

class QuizFail extends QuizState {}
