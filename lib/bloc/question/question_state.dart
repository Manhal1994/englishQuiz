part of 'question_bloc.dart';

@immutable
abstract class QuestionState {}

class QuestionInitial extends QuestionState {}

class QuestionAnswerdState extends QuestionState {
  final bool correct;
  final int userAnswer;
  QuestionAnswerdState(this.correct, this.userAnswer);
}
