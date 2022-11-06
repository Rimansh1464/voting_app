
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class voteProvider extends ChangeNotifier{

bool vot = false;

    savevote() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();

     vot = prefs.getBool("vot")!;
     notifyListeners();


   }

}