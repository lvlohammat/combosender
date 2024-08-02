import 'package:flutter/material.dart';
import 'package:combosender/screens/detail/components/game_card.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../constants.dart';
import '../../../providers/games_provider.dart';

class GameTimelineTile extends StatelessWidget {
  const GameTimelineTile({
    super.key,
    required this.game,
    required this.isFirst,
    required this.isLast,
    required this.copiedIndex,
    required this.onCopyText,
  });

  final Game game;
  final bool isFirst;
  final bool isLast;
  final int? copiedIndex;
  final VoidCallback onCopyText;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.06,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 40,
        height: 40,
        indicator: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.gamepad,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
      beforeLineStyle: const LineStyle(
        color: kPrimaryColor,
        thickness: 2,
      ),
      afterLineStyle: const LineStyle(
        color: kPrimaryColor,
        thickness: 2,
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(10),
        child: GameCard(
          game: game,
          copiedIndex: copiedIndex,
          onCopyText: onCopyText,
        ),
      ),
    );
  }
}
