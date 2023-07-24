import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/ui/screen/quize_page.dart';
import '../../bloc/quiz/quiz_bloc.dart';
import '../../data/repositories/quiz_repository.dart';

class QuizResultPage extends StatefulWidget {
  final int score;
  const QuizResultPage({super.key, required this.score});

  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double scorePercent = 0.0;

  @override
  void initState() {
    animateScore();
   
    super.initState();
  }

   animateScore(){
 _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = _controller;
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      setState(() {
        scorePercent += widget.score * 100 / 15;
        _animation = Tween<double>(
          begin: _animation.value,
          end: scorePercent,
        ).animate(CurvedAnimation(
          curve: Curves.fastOutSlowIn,
          parent: _controller,
        ));
      });
      _controller.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "English Quiz",
            style: textTheme.headline6?.copyWith(color: Colors.black),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Your result",
                  style: textTheme.headline4?.copyWith(color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Center(
                      child: Text(
                        "${_animation.value.round()} %",
                        textAlign: TextAlign.center,
                        style: textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "COREECT: ${widget.score}",
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      Text("MISTAKES: ${15 - widget.score}",
                          style: const TextStyle(color: Colors.blueGrey))
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  height: 1,
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
                const SizedBox(
                  height: 40,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                        builder: (context) {
                          return BlocProvider<QuizBloc>(
                            create: (context) => QuizBloc(QuizRepository()),
                            child: QuizPage(),
                          );
                        },
                      ), (_) => false);
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.pink, Colors.orange])),
                        child: const Text(
                          "RETAKE QUIZ",
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
