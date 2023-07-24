part of 'question_bloc.dart';

@immutable
abstract class QuestionEvent {}

class QuestionAnswerEvent extends QuestionEvent {
  final QuestionModel questionModel;
  final String userAnswer;
  QuestionAnswerEvent({required this.questionModel, required this.userAnswer});
}
