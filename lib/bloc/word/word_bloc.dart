import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz/data/models/option_position.dart';
import '../../styles.dart';
import '../../utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  List<String> userAnswers = [];
  List<OptionPosition> oldPostioned = [];

  WordBloc() : super(WordInitial()) {
    on<WordEvent>((event, emit) {
      if (event is ChooseWordEvent) {
        if (!userAnswers.contains(event.optionPosition.text)) {
          double tempRight = 0;
          double tempTop = 25.h;
          for (var i = 0; i < userAnswers.length; i++) {
            tempRight =
                tempRight + getTexWidth(event.context, userAnswers[i], style);
          }
          event.optionPosition.right = tempRight;
          event.optionPosition.top = tempTop;
          userAnswers.add(event.optionPosition.text);
          tempRight = 0;
          emit(WordSelected(event.optionPosition));
        } else {
          event.optionPosition.right = oldPostioned
              .where((element) => element.text == event.optionPosition.text)
              .first
              .right;
          event.optionPosition.top = oldPostioned
              .where((element) => element.text == event.optionPosition.text)
              .first
              .top;
          userAnswers
              .removeWhere((element) => element == event.optionPosition.text);
          emit(WordSelected(event.optionPosition));
        }
      }
    });
  }
}
