class QuestionModel {
  String id;
  String category;
  int type;
  String text;
  List<String> options = [];
  String answer;
  String explaniation;

  QuestionModel(
      {required this.id,
      required this.category,
      required this.type,
      required this.text,
      required this.options,
      required this.answer,
      required this.explaniation});

  QuestionModel.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        category = map["category"],
        type = map["type"],
        text = map["text"],
        answer = map["answer"],
        explaniation = map["explaniation"] {
    (map["options"] as Iterable).forEach((element) {
      options.add(element);
    });
  }
}
