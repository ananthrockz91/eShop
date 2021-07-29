import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppConfig.primaryColor, AppConfig.secondaryColor],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            tileMode: TileMode.clamp,
          ),
        ),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(80.0),
                    elevation: 8.0,
                    child: Container(
                      height: 160.0,
                      width: 160.0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(AppConfig.sharedPreferences.getString(AppConfig.userAvatarUrl)),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),
                  Text(AppConfig.sharedPreferences.getString(AppConfig.userName), style: TextStyle(color: Colors.white, fontSize: 35.0, fontFamily: AppFont.appFont),),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.white,),
                    title: Text('Home', style: TextStyle(color: Colors.white),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (context) => StoreHome());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10.0, color: Colors.white, thickness: 2.0, indent: 10.0, endIndent: 10.0,),
                  ListTile(
                    leading: Icon(Icons.reorder, color: Colors.white,),
                    title: Text('My Orders', style: TextStyle(color: Colors.white),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (context) => MyOrders());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10.0, color: Colors.white, thickness: 2.0, indent: 10.0, endIndent: 10.0,),
                  ListTile(
                    leading: Icon(Icons.shopping_cart, color: Colors.white,),
                    title: Text('My Cart', style: TextStyle(color: Colors.white),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (context) => CartPage());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10.0, color: Colors.white, thickness: 2.0, indent: 10.0, endIndent: 10.0,),
                  ListTile(
                    leading: Icon(Icons.search, color: Colors.white,),
                    title: Text('Search', style: TextStyle(color: Colors.white),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (context) => SearchProduct());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10.0, color: Colors.white, thickness: 2.0, indent: 10.0, endIndent: 10.0,),
                  ListTile(
                    leading: Icon(Icons.add_location, color: Colors.white,),
                    title: Text('Add New address', style: TextStyle(color: Colors.white),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (context) => AddAddress());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10.0, color: Colors.white, thickness: 2.0, indent: 10.0, endIndent: 10.0,),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.white,),
                    title: Text('Logout', style: TextStyle(color: Colors.white),),
                    onTap: (){
                     AppConfig.auth.signOut().then((c){
                       Route route = MaterialPageRoute(builder: (context) => AuthenticScreen());
                       Navigator.pushReplacement(context, route);
                     });

                    },
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
