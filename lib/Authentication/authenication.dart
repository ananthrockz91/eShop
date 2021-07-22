import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppConfig.primaryColor, AppConfig.secondaryColor],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(AppConfig.appName,
            style: TextStyle(
              fontSize: SizeConfig.fontSize * 10,
              color: Colors.white,
              fontFamily: AppFont.appFont,
            ),),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.lock, color: Colors.white,),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.perm_contact_calendar, color: Colors.white,),
                text: "Register",
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppConfig.primaryColor, AppConfig.secondaryColor],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              tileMode: TileMode.clamp,
            ),
          ),
          child: TabBarView(
            children: [
              Login(),
              Register(),
            ],
          ),
        ),
      ),
    );
  }
}
