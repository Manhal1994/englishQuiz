import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz/bloc/word/word_bloc.dart';
import 'package:quiz/data/models/question_model.dart';
import 'package:quiz/styles.dart';
import 'package:quiz/ui/widgets/explaniation_widget.dart';
import '../../bloc/question/question_bloc.dart';
import '../../data/models/option_position.dart';
import '../../helper/play_audio.dart';
import '../../helper/scroll_to_explaniation.dart';

class CompleteSentenceQuestionPageItem extends StatefulWidget {
  final QuestionModel questionModel;
  final Function(bool) onAnswered;

  const CompleteSentenceQuestionPageItem(
      {Key? key, required this.questionModel, required this.onAnswered})
      : super(key: key);

  @override
  CompleteWordQuestionPageItemState createState() =>
      CompleteWordQuestionPageItemState();
}

class CompleteWordQuestionPageItemState
    extends State<CompleteSentenceQuestionPageItem> {
  List<OptionPosition> optionPostioned = [];
  List<OptionPosition> oldOptionPostioned = [];
  bool selected = true;
  String name = "";
  final ScrollController scrollController = ScrollController();

  setOptionsPositions(width) {
    optionPostioned =
        AlignQuestionOptionItem(widget.questionModel.options, context, width)
            .textsToOptionPositioned();
    for (var element in optionPostioned) {
      oldOptionPostioned.add(element.copy());
    }

    BlocProvider.of<WordBloc>(context).oldPostioned = oldOptionPostioned;
  }

  List<String> userAnswers = [];
  bool isQuestionAnswerd = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding:  EdgeInsets.all(16.0.h),
                    child: LayoutBuilder(builder: (context, constrain) {
                      if (optionPostioned.isEmpty) {
                        setOptionsPositions(constrain.maxWidth);
                      }
                      // ----------------------------- Question text widget---------------------
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                padding:  EdgeInsets.all(24.h),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          spreadRadius: 2)
                                    ],
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  widget.questionModel.text,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                )),
                          ),
                        ],
                      );
                    }),
                  ),
                  Expanded(child: LayoutBuilder(builder: (context, constrain) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 80.h,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 2.h,
                            width: constrain.maxWidth,
                            decoration:
                                BoxDecoration(color: Colors.grey.shade200),
                          ),
                        ),
                        // ------------------------------ questions options' background -----------------------------------------
                        ...oldOptionPostioned.map((postion) => Positioned(
                              top: postion.top,
                              left: postion.right,
                              child: Container(
                                  height: 45.h,
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            spreadRadius: 2)
                                      ],
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(postion.text,
                                          textAlign: TextAlign.center,
                                          style: hiddenTextStyle),
                                    ],
                                  )),
                            )),
                        // ------------------------------------------------- questions options -----------------------------------------
                        ...optionPostioned.map((postion) {
                          return BlocBuilder<WordBloc, WordState>(
                            builder: (context, state) {
                              return AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                top: state is WordSelected &&
                                        state.optionPosition.text ==
                                            postion.text
                                    ? state.optionPosition.top
                                    : postion.top,
                                left: state is WordSelected &&
                                        state.optionPosition.text ==
                                            postion.text
                                    ? state.optionPosition.right
                                    : postion.right,
                                child: GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<WordBloc>(context)
                                        .add(ChooseWordEvent(postion, context));
                                  },
                                  child: Container(
                                      height: 45.h,
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                spreadRadius: 2)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(postion.text,
                                              textAlign: TextAlign.center,
                                              style: style),
                                        ],
                                      )),
                                ),
                              );
                            },
                          );
                        }).toList(),
                        //---------------------------------------------Explanation/ result Widget----------------------------------
                        Positioned(
                          top: MediaQuery.of(context).size.height / 2,
                          right: 0,
                          left: 0,
                          child: BlocBuilder<QuestionBloc, QuestionState>(
                            builder: (context, state) {
                              return AnimatedOpacity(
                                  duration: const Duration(seconds: 1),
                                  opacity:
                                      state is QuestionAnswerdState ? 1 : 0,
                                  child: state is QuestionAnswerdState
                                      ? ExplaniationWidget(
                                          correct: state.correct,
                                          text:
                                              widget.questionModel.explaniation,
                                        )
                                      : const SizedBox.shrink());
                            },
                          ),
                        ),
                      ],
                    );
                  })),
                ],
              ),
            ),
          ),
          //---------------------------------------------Answer Question Widget----------------------------------

          Positioned(
              bottom: 16,
              right: 16,
              child: BlocConsumer<QuestionBloc, QuestionState>(
                  listener: (context, state) {
                    if (state is QuestionAnswerdState) {
                      playAudio(state.correct);
                      widget.onAnswered(state.correct);
                      scrollToExplaniation(scrollController, constraint);
                    }
                  },
                  builder: (context, state) => state is QuestionAnswerdState
                      ? const SizedBox.shrink()
                      : FloatingActionButton(
                          child: const Icon(Icons.arrow_forward_ios_outlined),
                          onPressed: () {
                            BlocProvider.of<QuestionBloc>(context).add(
                                QuestionAnswerEvent(
                                    questionModel: widget.questionModel,
                                    userAnswer:
                                        BlocProvider.of<WordBloc>(context)
                                            .userAnswers
                                            .join(" ")));
                          })))
        ],
      );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
