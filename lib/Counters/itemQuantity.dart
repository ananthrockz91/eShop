import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {

  int _numberOfItems = 0;

  int get numberOfItems => _numberOfItems;

  displayNumberIfItems(int number) async{
    _numberOfItems = number;

    await Future.delayed(Duration(milliseconds: 100), (){
      notifyListeners();
    });
  }


}
