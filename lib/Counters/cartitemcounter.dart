import 'package:flutter/foundation.dart';
import 'package:e_shop/Config/config.dart';

class CartItemCounter extends ChangeNotifier{

  int _counter = AppConfig.sharedPreferences.getStringList(AppConfig.userCartList).length -1;

  int get count => _counter;

Future<void> displayCartCount() async{

  int _counter = AppConfig.sharedPreferences.getStringList(AppConfig.userCartList).length -1;

  await Future.delayed(Duration(milliseconds: 100), (){
    notifyListeners();
  });

}

}