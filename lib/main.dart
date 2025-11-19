import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nexaflow/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
//related to web app
import 'package:flutter/foundation.dart';
//internet_connection_checker_plus
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final GlobalKey<ScaffoldMessengerState> rootMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBGb4C50O_DXKo-VCS5Kn0iSEbHxh_Up2c",
        appId: "1:773979981923:web:e56d09e35d64158c969056",
        messagingSenderId: "773979981923",
        projectId: "nexaflow-1d94b",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  // Quick Firebase test:
  // try {
  //   await FirebaseAuth.instance.signInAnonymously();
  // } catch (e) {
  //   print('Firebase Auth Error: $e');
  // }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription
  _connectivitySubscription; //user-defined variable for monitoring connectivity changes
  bool isOffline = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool hasInternet = await checkInternetConnection();
      final messenger = rootMessengerKey.currentState;
      if (messenger == null) return;
      isOffline = !hasInternet;
      if (!hasInternet) {
        messenger.showSnackBar(
          SnackBar(
            content: Text("No internet connection!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16.0),
            duration: Duration(days: 1),
          ),
        );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //onConnectivityChanged is a pre-defined function to listen to connectivity changes
      _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
        connectivityResult,
      ) async {
        await Future.delayed(const Duration(milliseconds: 500));
        bool hasInternet = await checkInternetConnection();
        final messenger = rootMessengerKey.currentState;
        if (messenger == null) return;
        if (!hasInternet && !isOffline) {
          isOffline = true;
          messenger.hideCurrentSnackBar();
          messenger.showSnackBar(
            SnackBar(
              content: Text("No internet connection!"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16.0),
              duration: Duration(days: 1),
            ),
          );
        } else if (hasInternet && isOffline) {
          isOffline = false;
          messenger.hideCurrentSnackBar();
          messenger.showSnackBar(
            SnackBar(
              content: Text("Back online"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16.0),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    });
  }

  Future<bool> checkInternetConnection() async {
    return await InternetConnection().hasInternetAccess;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  // This is the root widget of the application.
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: rootMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'NexaFlow',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.purple[200],
        //scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple[200],
          elevation: 2,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Splash(),
    );
  }
}
