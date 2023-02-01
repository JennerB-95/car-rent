import 'dart:async';

import 'package:car_rental/core.dart';
import 'package:car_rental/pages/started/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
/*
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();*/
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es'),
      ],
      locale: const Locale('es'),
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      //initialRoute: "initial-route",
      home: SaveSession(),
      routes: {
        //"initial-route": (BuildContext context) => SaveSession(),
        '/login': (BuildContext context) => LoginView(),
        '/home': (BuildContext context) => HomeView(),
        '/register': (BuildContext context) => RegisterView(),
        '/book_car': (BuildContext context) => BookCarView(),
      },
    );
  }
}

class SaveSession extends StatefulWidget {
  @override
  _SaveSessionState createState() => _SaveSessionState();
}

class _SaveSessionState extends State<SaveSession> {
  @override
  void initState() {
    super.initState();
    saveSession(context);
  }

  void saveSession(BuildContext context) async {
    Timer(Duration(seconds: 3), () async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (sharedPreferences.containsKey('session')) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (_) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (_) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: new AlwaysStoppedAnimation<Color>(
            Color(0xff333D55),
          ),
        ),
      ),
    );
  }
}
