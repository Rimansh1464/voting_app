import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter/provider/vote_provider.dart';
import 'package:firebase_flutter/views/HomePage.dart';
import 'package:firebase_flutter/views/show_vot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final value = prefs.getBool("vot") ?? false;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<voteProvider>(
        create: (context) => voteProvider(),
      )
    ],
    builder: (context, child) {
      return MaterialApp(
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => const HomePage(),
            'showVote': (context) => const showVote(),
          });
    },
  ));
}
