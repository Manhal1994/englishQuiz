import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz/bloc/question/question_bloc.dart';
import 'package:quiz/data/models/question_model.dart';
import 'package:quiz/helper/play_audio.dart';
import 'package:quiz/ui/widgets/explaniation_widget.dart';
import 'package:quiz/ui/widgets/option_item.dart';
import '../../helper/scroll_to_explaniation.dart';

class MultiChoistQuestionItem extends StatefulWidget {
  final QuestionModel questionModel;
  final Function(bool) onAnswered;

  const MultiChoistQuestionItem(
      {Key? key, required this.questionModel, required this.onAnswered})
      : super(key: key);

  @override
  MultiChoistQuestionItemState createState() => MultiChoistQuestionItemState();
}

class MultiChoistQuestionItemState extends State<MultiChoistQuestionItem> {
  final ScrollController scrollController = ScrollController();
  var selectedOption = -1;
  bool isQuestionAnswerd = false;

  Completer<List<QuestionModel>> questionsCompleter =
      Completer<List<QuestionModel>>();

  _onQuestionAnswer(QuestionAnswerdState state) {
     playAudio(widget.questionModel.answer ==
        widget.questionModel.options[state.userAnswer]);
    widget.onAnswered(state.correct);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(builder: (context, constraint) {
          return Stack(
            children: [
              Column(
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                           SizedBox(
                            height: 16.h,
                          ),

                          // ----------------------------- Question text widget---------------------

                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14),
                            decoration: BoxDecoration(
                                color: const Color(0xfff6f5f6),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              widget.questionModel.text,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  wordSpacing: 1.2,
                                  letterSpacing: 1.05),
                            ),
                          ),
                           SizedBox(
                            height: 32.h,
                          ),
                          // ----------------------------- Question options---------------------
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.questionModel.options.length,
                              itemBuilder: (context, index) => OptionItem(
                                    index: index,
                                    questionModel: widget.questionModel,
                                  )),
                          //---------------------------------------------Explanation/ result Widget----------------------------------

                          BlocConsumer<QuestionBloc, QuestionState>(
                            listener: (context, state) {
                              if (state is QuestionAnswerdState) {
                                _onQuestionAnswer(state);
                              
                                  if (scrollController.hasClients) {
                                   scrollToExplaniation(scrollController, constraint);

                                  }
                                
                              }
                            },
                            builder: (context, state) {
                              return AnimatedOpacity(
                                  duration: const Duration(seconds: 1),
                                  opacity:
                                      state is QuestionAnswerdState ? 1 : 0,
                                  child: state is QuestionAnswerdState
                                      ? ExplaniationWidget(
                                          text: widget.questionModel.answer,
                                          correct: state.correct,
                                        )
                                      : const SizedBox.shrink());
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
