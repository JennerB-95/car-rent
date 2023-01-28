import 'dart:async';

import 'package:car_rental/core.dart';
import 'package:car_rental/pages/started/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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


/*import 'package:car_rental/pages/started/prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core.dart';

void main() async {
  /// Make sure you add this line here, so the plugin can access the native side
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  final sessionManager = SessionManager();
  Get.put(sessionManager);
  runApp(GetMaterialApp(
    title: 'Car Rental',
    initialBinding: MainBinding(),
    //home: initialRoute ? MainView() : LoginView(),
    initialRoute: _getInitialRoute(sessionManager),
    getPages: AppPages.routes,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.mulishTextTheme(),
    ),
    debugShowCheckedModeBanner: false,
    defaultTransition: Transition.cupertino,
    opaqueRoute: Get.isOpaqueRouteDefault,
    popGesture: Get.isPopGestureEnable,
    transitionDuration: Duration(milliseconds: 230),
  ));
}

String _getInitialRoute(SessionManager sessionManager) {
  final session = sessionManager.getSession();
  print("the session ${session}");
  if (session != null) {
    print("home print");
    return '/';
  } else {
    print("login print");
    return '/login';
  }
}

class SessionManager {
  Future<void> saveSession(String session) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('session', session);
  }

  Future<String> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session');
  }
}
*/