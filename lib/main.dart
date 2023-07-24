import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz/bloc/quiz/quiz_bloc.dart';
import 'package:quiz/ui/screen/quize_page.dart';
import 'package:quiz/data/repositories/quiz_repository.dart';
import 'package:quiz/ui/screen/quiz_result_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder:(context,child){
        return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<QuizBloc>(
          create: (context) => QuizBloc(QuizRepository()),
          child: QuizPage(),
        ),
      );}
    );
  }
}
