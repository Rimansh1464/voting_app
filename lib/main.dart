import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter/views/HomePage.dart';

import 'package:firebase_flutter/views/show_vot.dart';
import 'package:flutter/material.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp( MaterialApp(initialRoute: '/',
    debugShowCheckedModeBanner: false,
    routes:{
      '/': (context) => const HomePage(),


      'showVote' : (context)=> const showVote(),
    }
  ));
}
