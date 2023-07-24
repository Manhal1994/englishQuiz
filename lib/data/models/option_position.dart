import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz/styles.dart';
import 'package:quiz/utils/utils.dart';

List<double> rows = [];

class OptionPosition {
  double right;
  double top;
  String text;
  OptionPosition({required this.right, required this.top, required this.text});

  copy() {
    return OptionPosition(right: right, text: text, top: top);
  }
}

class AlignQuestionOptionItem {
  List<String> texts;
  BuildContext context;
  double maxWidth;
  List<OptionPosition> optionPositions = [];

  AlignQuestionOptionItem(this.texts, this.context, this.maxWidth);

  List<OptionPosition> textsToOptionPositioned() {
    double rowWidth = 0;
    double top = 100.h;
    int starindex = 0;

    for (var i = 0; i < texts.length; i++) {
      double width = getTexWidth(context, texts[i], style);
      if (rowWidth + width <= maxWidth) {
        rowWidth = rowWidth + width;
        if (i == texts.length - 1) {
          double start = maxWidth / 2 - rowWidth / 2;
          var temp = start;
          top = top + 80.h;
          buildRow(temp, texts.sublist(starindex, i + 1), top);
        }
      } else {
        double start = maxWidth / 2 - rowWidth / 2;
        var temp = start;
        top = top + 80.h;
        buildRow(temp, texts.sublist(starindex, i), top);
        rowWidth = 0;
        starindex = i;
      }
    }

    return optionPositions;
  }

  buildRow(double startPont, List<String> fd, double top) {
    var temp = startPont;
    for (var element in fd) {
      debugPrint("I");
      optionPositions.add(OptionPosition(right: temp, top: top, text: element));
      double width = getTexWidth(context, element, style);
      temp = temp + width;
    }
  }
}
