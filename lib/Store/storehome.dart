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
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(delegate: SearchBoxDelegate(), pinned: true,),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('items').limit(15).orderBy("publishedDate", descending: true).snapshots(),
              builder: (context, dataSnapshot){
                return !dataSnapshot.hasData ? SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(),),)
                    : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                  itemBuilder: (context, index){
                    ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                    return sourceInfo(model, context);
                  },
                  itemCount: dataSnapshot.data.documents.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(builder: (context) => ProductPage(itemModel: model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl, width: 140.0, height: 140.0),
            SizedBox(width: 4.0,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0,),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                       child: Text(model.title, style: TextStyle(color: Colors.black, fontSize: 12.0),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0,),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(model.shortInfo, style: TextStyle(color: Colors.black54, fontSize: 14.0),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.pink,
                      ),
                      alignment: Alignment.topLeft,
                      width: 40.0,
                      height: 43.0,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("50%", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.normal),),
                            Text("OFF", style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.normal),),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: [
                              Text(r"Original Price: $ ",style: TextStyle(fontSize: 14.0, color: Colors.grey, decoration: TextDecoration.lineThrough),),
                              Text(model.price.toString(), style: TextStyle(fontSize: 14.0, color: Colors.grey, decoration: TextDecoration.lineThrough),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.0),
                          child: Row(
                            children: [
                              Text(r"New Price: ",style: TextStyle(fontSize: 14.0, color: Colors.grey),),
                              Text(r"$ ",style: TextStyle(color: Colors.red),),
                              Text((model.price / 2).toString(),
                                style: TextStyle(fontSize: 14.0, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Flexible(
                    child: Container(


                )),
                Align(
                  alignment: Alignment.centerRight,
                  child: removeCartFunction == null
                      ? IconButton(icon: Icon(Icons.add_shopping_cart, color: Colors.pinkAccent,), onPressed: (){
                        checkItemInCart(model.shortInfo, context);
                  })
                      :  IconButton(icon: Icon(Icons.remove_shopping_cart), onPressed: (){})
                ),
              ],
            )),
          ],
        ),
      ),
    ),
  );
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}



void checkItemInCart(String productID, BuildContext context)
{



}
