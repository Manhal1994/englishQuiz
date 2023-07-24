import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/question_model.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(QuestionInitial()) {
    on<QuestionEvent>((event, emit) {
      if (event is QuestionAnswerEvent) {
        if (event.userAnswer ==
            event.questionModel.answer) {
          emit(QuestionAnswerdState(true, event.questionModel.options.indexOf(event.userAnswer)));
        } else {
          emit(QuestionAnswerdState(false,  event.questionModel.options.indexOf(event.userAnswer)));
        }
      }
    });
  }
}
