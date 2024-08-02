import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../constants.dart';
import '../../../providers/games_provider.dart';

class GameTitleAndDate extends StatelessWidget {
  const GameTitleAndDate({
    super.key,
    required this.game,
  });

  final Game game;

  String _convertToPersianDate(String date) {
    final dateTime = DateTime.parse(date);
    return dateTime.toPersianDateStr(showDayStr: true);
  }

  @override
  Widget build(BuildContext context) {
    return game.dailyComboImage != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    style: kTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _convertToPersianDate(game.date),
                    style: const TextStyle(
                      fontSize: 16,
                      color: kSubtitleColor,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(top: 45),
                            decoration: BoxDecoration(
                              color: kBackgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 45),
                                SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      game.dailyComboImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Daily Combo Image',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Here is the daily combo image for the game.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: kSubtitleColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            child: CircleAvatar(
                              backgroundColor: kPrimaryColor,
                              radius: 45,
                              child: CircleAvatar(
                                backgroundColor: kSubtitleColor,
                                radius: 40,
                                backgroundImage: NetworkImage(game.gameIcon),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: kSubtitleColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      game.dailyComboImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                game.title,
                style: kTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
              ),
              Text(
                _convertToPersianDate(game.date),
                style: const TextStyle(
                  fontSize: 16,
                  color: kSubtitleColor,
                ),
              ),
            ],
          );
  }
}
