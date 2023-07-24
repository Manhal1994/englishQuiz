import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/bloc/question/question_bloc.dart';
import 'package:quiz/bloc/quiz/quiz_bloc.dart';
import 'package:quiz/bloc/word/word_bloc.dart';
import 'package:quiz/ui/widgets/complete_sentence_question_item.dart';
import 'package:quiz/ui/widgets/multi_choise_question_item.dart';
import '../../helper/navigation_strategy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizPage extends StatefulWidget {
  QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizOageState();
}

class _QuizOageState extends State<QuizPage> {
  late final PageController _pageController;
  final quizIndex = ValueNotifier(0);
  int _score = 0;
  var numberOfQuestion = ValueNotifier(0);
  var isQestionAnswered = ValueNotifier(false);
  late NavigationStrategy navigationStrategy;

  _onQuestionAnswer(
      {required bool correct, required int index, required numQuestions}) {
    if (correct) {
      _score++;
    }
    if (index < numQuestions - 1) {
      navigationStrategy = NextQuestionNavigate(_pageController);
    } else {
      navigationStrategy = ResultPageNavigate(context, _score);
    }
    isQestionAnswered.value = true;
  }

  @override
  void initState() {
    BlocProvider.of<QuizBloc>(context).add(QuizFetchEvent());
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ValueListenableBuilder(
            valueListenable: isQestionAnswered,
            builder: (context, bool value, child) {
              return Visibility(
                visible: value,
                maintainState: true,
                maintainAnimation: true,
                child: FloatingActionButton(
                    onPressed: () {
                      navigationStrategy.navigate();
                      isQestionAnswered.value = false;
                    },
                    child: const Icon(Icons.arrow_forward_ios_outlined)),
              );
            }),
        body: SafeArea(
            child:
                BlocConsumer<QuizBloc, QuizState>(listener: (context, state) {
          if (state is QuizLoaded) {
            numberOfQuestion.value = state.questions.length;
          }
        }, builder: (context, state) {
          if (state is QuizLoaded) {
            return Column(
              children: [
                 SizedBox(
                  height: 10.h,
                ),
                const Text(
                  "English Quiz",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                 SizedBox(
                  height: 12.h,
                ),
                ValueListenableBuilder(
                  valueListenable: quizIndex,
                  builder: (context, value, child) => Container(
                    height: 45.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xfff6f1f6),
                    ),
                    child: Center(
                        child: Text(
                            "${quizIndex.value + 1}/${state.questions.length} - ${state.questions[quizIndex.value].category}")),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      itemCount: state.questions.length,
                      onPageChanged: (value) => quizIndex.value++,
                      itemBuilder: ((context, index) =>
                          BlocProvider<QuestionBloc>(
                              create: (context) => QuestionBloc(),
                              child: state.questions[index].type == 1
                                  ? MultiChoistQuestionItem(
                                      onAnswered: (correct) {
                                        _onQuestionAnswer(
                                            correct: correct,
                                            index: index,
                                            numQuestions:
                                                state.questions.length);
                                      },
                                      questionModel: state.questions[index],
                                    )
                                  : BlocProvider(
                                      create: (context) => WordBloc(),
                                      child: CompleteSentenceQuestionPageItem(
                                        onAnswered: (correct) {
                                          _onQuestionAnswer(
                                              correct: correct,
                                              index: index,
                                              numQuestions:
                                                  state.questions.length);
                                        },
                                        questionModel: state.questions[index],
                                      ),
                                    )))),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator.adaptive();
          }
        })));
  }
}
