import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz/bloc/question/question_bloc.dart';
import 'package:quiz/data/models/question_model.dart';

class OptionItem extends StatelessWidget {
  final QuestionModel questionModel;
  final int index;
  const OptionItem({
    required this.questionModel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuestionBloc, QuestionState>(
      listener: (context, state) {},
      builder: (context, state) {
        return InkWell(
          onTap: () {
            BlocProvider.of<QuestionBloc>(context).add(QuestionAnswerEvent(
                questionModel: questionModel, userAnswer: questionModel.options[index]));
          },
          child: Container(
            height: 64.h,
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade200, spreadRadius: 2)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  questionModel.options[index],
                  style: const TextStyle(),
                ),
                Visibility(
                    visible: (state is QuestionAnswerdState) &&
                        (questionModel.options[index] == questionModel.answer ||
                            questionModel.options[state.userAnswer] ==
                                questionModel.options[index]),
                    child: questionModel.options[index] == questionModel.answer
                        ? const Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : const Icon(
                            Icons.cancel_outlined,
                            color: Colors.redAccent,
                          )),
              ],
            ),
          ),
        );
      },
    );
  }
}
