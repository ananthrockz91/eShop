import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
      return AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
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
        centerTitle: true,
        title: Text(AppConfig.appName,
          style: TextStyle(
            fontSize: SizeConfig.fontSize * 10,
            color: Colors.white,
            fontFamily: AppFont.appFont,
          ),),
        bottom: bottom,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.pink,),
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (context) => CartPage());
                  Navigator.pushReplacement(context, route);
                },
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.pink,),
                onPressed: (){
                  AppConfig.auth.signOut().then((c){
                    Route route = MaterialPageRoute(builder: (context) => AuthenticScreen());
                    Navigator.pushReplacement(context, route);
                  });
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Stack(
                  children: [
                    Icon(Icons.brightness_1, size: 20, color: Colors.green,),
                    Consumer<CartItemCounter>(
                      builder: (context, counter, _){
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(counter.count.toString(), style: TextStyle(color: Colors.white),),
                        );
                      },
                    ),

                  ],
                ),
              ),

            ],
          ),
        ],
      );
  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
