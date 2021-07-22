import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Counters/BookQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.auth = FirebaseAuth.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            title: 'e-Shop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.green,
            ),
            home: SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>

{

  @override
  void initState() {
    super.initState();
    displaySplashScreen();
  }

  displaySplashScreen(){

    Timer(Duration(seconds: 5), () async{
      if(await AppConfig.auth.currentUser() != null) {
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppConfig.primaryColor, AppConfig.secondaryColor],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppConstants.welcomeScreenImage),
                SizedBox(height: SizeConfig.blockSizeHorizontal * 10,),
                Text(AppConstants.brandTagLine, style: TextStyle(color: Colors.white, fontSize: SizeConfig.fontSize * 5), ),
              ],
            )),
      ),
    );
  }
}
