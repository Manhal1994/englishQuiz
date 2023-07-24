import 'package:flutter/material.dart';

class ExplaniationWidget extends StatelessWidget {
  final String text;
  final bool correct;
  const ExplaniationWidget({super.key, required this.text,required this.correct});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          color: correct? Colors.green.shade50:Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(color:correct? Colors.green.shade500:Colors.red.shade500, fontSize: 17),
        ),
      ),
    );
  }
}
