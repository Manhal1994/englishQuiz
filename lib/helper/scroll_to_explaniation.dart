import 'package:flutter/material.dart';

scrollToExplaniation(
    ScrollController scrollController, BoxConstraints constraints) {
  Future.delayed(const Duration(milliseconds: 1200), () {
    if (scrollController.hasClients) {
      scrollController.animateTo(constraints.maxHeight / 20,
          duration: const Duration(seconds: 1), curve: Curves.linearToEaseOut);
    }
  });
}
