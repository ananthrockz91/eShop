import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier{

  double _totalAmount = 0;

  double get totalAmount => _totalAmount;

  displayTotal(double newTotal) async {

    _totalAmount = newTotal;

    await Future.delayed(Duration(milliseconds: 100), (){
      notifyListeners();
    });

  }



}