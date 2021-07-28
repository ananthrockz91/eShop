import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
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
          ),
          drawer: MyDrawer(),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell();
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}



void checkItemInCart(String productID, BuildContext context)
{
}
