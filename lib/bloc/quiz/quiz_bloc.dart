import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quiz/data/repositories/quiz_repository.dart';

import '../../data/models/question_model.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _quizRepository;
  QuizBloc(this._quizRepository) : super(QuizInitial()) {
    on<QuizEvent>((event, emit) async {
      if (event is QuizFetchEvent) {
        final questions = await _quizRepository.fetchQuiz();
        emit(QuizLoaded(questions));
      }
    });
  }
}
