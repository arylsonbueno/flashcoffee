import 'package:flashcoffee/pages/root.dart';
import 'package:flashcoffee/services/authentication.dart';
import 'package:flashcoffee/services/basket_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await FirebaseCore.init();
  } catch (e) {
    print("Failed to initialize Firebase: $e");
  }

  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Auth auth = Auth();

  //VoiceCommand voiceCommand = VoiceCommand();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlashCoffee',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Color(0xFF0E5EDA),
            secondary: Color(0xFFA7C5F8).withOpacity(0.6),
            tertiary: Color(0xFF0E5EDA),
            outline: Colors.grey[600]!,
            surfaceDim: Color(0xfff0f0f0),
          ),
        ),
        darkTheme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
          ),
          colorScheme: ColorScheme.dark(
            primary: Color(0xFFc1e8ff),
            secondary: Color(0xFF004c69).withOpacity(0.5),
            tertiary: Color(0xFF76d1ff),
            outline: Colors.white.withOpacity(0.8),
            surfaceDim: Colors.black,
          ),
        ),
        home: RootPage(auth));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

}
