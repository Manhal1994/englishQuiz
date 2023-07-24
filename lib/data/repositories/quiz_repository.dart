import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/question_model.dart';

class QuizRepository {
  Future<List<QuestionModel>> fetchQuiz() async {
    var data = await rootBundle.loadString('assets/data/questions_json.json');
    var decodedString = json.decode(data);
    var questions = (decodedString as Iterable)
        .map((e) => QuestionModel.fromJson(e))
        .toList();
    return questions;
  }
}
