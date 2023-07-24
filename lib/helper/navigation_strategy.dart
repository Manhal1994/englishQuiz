import 'package:flutter/material.dart';
import 'package:quiz/ui/screen/quiz_result_page.dart';

abstract class NavigationStrategy {
  void navigate();
}

class NextQuestionNavigate extends NavigationStrategy {
  final PageController _pageController;
   NextQuestionNavigate(this._pageController);
  @override
  void navigate() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
  }
}

class ResultPageNavigate extends NavigationStrategy {
  final BuildContext context;
  final int score;
  ResultPageNavigate(this.context, this.score);

  @override
  void navigate() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return QuizResultPage(
          score: score,
        );
      },
    ));
  }
}
