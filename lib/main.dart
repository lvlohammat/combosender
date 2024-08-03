import 'package:combosender/providers/games_provider.dart';
import 'package:combosender/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:combosender/constants.dart';
import 'package:combosender/screens/detail/detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'fqoDTwbuolpZUtv0fjz55eUYk1vz73DDMQXQG4Am';
  const keyClientKey = '3VV7mIyvsS9YmjzVA7lSexpckOVpX1b0L0Bm33oj';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    debug: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GamesProvider>(
          create: (context) => GamesProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Daily Combo',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Vazirmatn',
          colorScheme: kColorScheme,
          scaffoldBackgroundColor: kBackgroundColor,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor: kBackgroundColor,
            foregroundColor: kTitleColor,
            iconTheme: const IconThemeData(color: kSubtitleColor),
          ),
        ),
        home: const HomeScreen(),
        routes: {
          DetailScreen.routeName: (context) => const DetailScreen(),
        },
      ),
    );
  }
}
