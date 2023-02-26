import 'package:flutter/material.dart';

class AnimatedBar extends AnimatedWidget {
  const AnimatedBar({super.key, required Animation<double> animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      return Stack(
        children: [
          Container(
            height: 3,
            width: maxWidth * animation.value,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ],
      );
    });
  }
}
