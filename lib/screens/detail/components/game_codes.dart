import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../providers/games_provider.dart';

class GameCode extends StatelessWidget {
  const GameCode({
    super.key,
    required this.game,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(
        game.code!.split(' ').length,
        (index) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: kPrimaryColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${index + 1}. ${game.code!.split(' ')[index]}',
              style: kMonoTextStyle(color: kTitleColor),
            ),
          );
        },
      ),
    );
  }
}
