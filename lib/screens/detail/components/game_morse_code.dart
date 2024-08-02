import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../providers/games_provider.dart';

class GameMorseCode extends StatelessWidget {
  const GameMorseCode({
    super.key,
    required this.game,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    final morseCode = kTextToMorse(game.decodedMorseCode!);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (game.decodedMorseCode != null)
            Text(
              'Morse Code: ${game.decodedMorseCode!.toUpperCase()}',
              style: kMonoTextStyle(
                  color: kColorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 10,
            runSpacing: 4.0,
            children: morseCode
                .replaceAll('.', '⚫')
                .replaceAll('-', '➖')
                .split(' ')
                .map((char) => Container(
                      margin: const EdgeInsets.only(right: 2.5),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        char,
                        style: const TextStyle(
                            fontSize: 14, fontFamily: 'NotoColorEmoji'),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
