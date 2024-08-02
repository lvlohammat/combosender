import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color kBackgroundColor = const Color(0xffF5F8FA);
const Color kForegroundColor = Color(0xFFEBEEF0);
const Color kPrimaryColor = Color(0xFF3AA3B7);
const Color kTitleColor = Color(0xFF030404);
const Color kSubtitleColor = Color(0xFFB5BFCD);
const Color kHeartColor = Color(0xFFDE2C4F);
ColorScheme kColorScheme = ColorScheme.fromSeed(seedColor: kPrimaryColor);

TextStyle kTextStyle({
  double fontSize = 14,
  required Color color,
  FontWeight fontWeight = FontWeight.normal,
}) {
  try {
    return GoogleFonts.nunitoSans(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  } catch (e) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontFamily: 'Vazirmatn',
    );
  }
}

TextStyle kMonoTextStyle({
  double fontSize = 14,
  required Color color,
  FontWeight fontWeight = FontWeight.normal,
}) {
  try {
    return TextStyle(
      fontFamily: 'jetbrains',
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  } catch (e) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontFamily: 'Vazirmatn',
    );
  }
}

const kFormBackgroundColor = Color(0xFF2E3440);
const kFillColor = Color(0xFF3B4252);
const kFormForegroundColor = Color(0xFFD8DEE9);

TextStyle kFormTextStyle({Color? color}) {
  return TextStyle(color: color ?? kFormForegroundColor);
}

String kTextToMorse(String decodedMorseCode) {
  final morseCodeMap = {
    'A': '.-',
    'B': '-...',
    'C': '-.-.',
    'D': '-..',
    'E': '.',
    'F': '..-.',
    'G': '--.',
    'H': '....',
    'I': '..',
    'J': '.---',
    'K': '-.-',
    'L': '.-..',
    'M': '--',
    'N': '-.',
    'O': '---',
    'P': '.--.',
    'Q': '--.-',
    'R': '.-.',
    'S': '...',
    'T': '-',
    'U': '..-',
    'V': '...-',
    'W': '.--',
    'X': '-..-',
    'Y': '-.--',
    'Z': '--..',
    '1': '.----',
    '2': '..---',
    '3': '...--',
    '4': '....-',
    '5': '.....',
    '6': '-....',
    '7': '--...',
    '8': '---..',
    '9': '----.',
    '0': '-----',
  };

  String morseCode = '';
  for (var char in decodedMorseCode.toUpperCase().split('')) {
    if (morseCodeMap.containsKey(char)) {
      morseCode += '${morseCodeMap[char]!} ';
    } else {
      morseCode += '$char ';
    }
  }
  return morseCode.trim();
}
