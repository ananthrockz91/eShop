import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  final imagePicker = ImagePicker();
  File imageFile;
  var pickedFile;
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController shortInfoTextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;



  @override
  Widget build(BuildContext context) {
    return imageFile == null ? displayAdminHomeScreen() : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
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
        leading: IconButton(
          icon: Icon(Icons.border_color),
          onPressed: () {
            Route route =
                MaterialPageRoute(builder: (context) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          TextButton(
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (context) => AuthenticScreen());
                Navigator.pushReplacement(context, route);
              },
              child: Text('Logout',
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold))),
        ],
      ),
      body: getAdminHomeScreen(),
    );
  }

  displayAdminUploadFormScreen() {
    return Scaffold(
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: clearFormInfo,
        ),
        title: Text('New Product', style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),),
        actions: [
          TextButton(onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
          child: Text('Add', style: TextStyle(color: Colors.pink, fontSize: 16.0, fontWeight: FontWeight.bold),)),
        ],
      ),
      body: ListView(
            children: [
              uploading ? circularProgress() : Text(''),
              Container(
                height: 230.0,
                width: SizeConfig.screenWidth * 0.8,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 16/9,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(imageFile), fit: BoxFit.cover,
                        )
                      ),
                      padding: EdgeInsets.only(top: 12.0),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.perm_device_info, color: Colors.pink,),
                title: Container(
                  width: 250.0,
                  child: TextField(
                    style: TextStyle(
                      color: Colors.deepPurpleAccent),
                    controller: shortInfoTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(
                        color: Colors.deepPurpleAccent,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.pink,),
              ListTile(
                leading: Icon(Icons.perm_device_info, color: Colors.pink,),
                title: Container(
                  width: 250.0,
                  child: TextField(
                    style: TextStyle(
                        color: Colors.deepPurpleAccent),
                    controller: titleTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Short Info",
                      hintStyle: TextStyle(
                        color: Colors.deepPurpleAccent,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.pink,),
              ListTile(
                leading: Icon(Icons.perm_device_info, color: Colors.pink,),
                title: Container(
                  width: 250.0,
                  child: TextField(
                    style: TextStyle(
                        color: Colors.deepPurpleAccent),
                    controller: descriptionTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(
                        color: Colors.deepPurpleAccent,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.pink,),
              ListTile(
                leading: Icon(Icons.perm_device_info, color: Colors.pink,),
                title: Container(
                  width: 250.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Colors.deepPurpleAccent),
                    controller: priceTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Price",
                      hintStyle: TextStyle(
                        color: Colors.deepPurpleAccent,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.pink,),

            ],
      ),
    );
  }

  getAdminHomeScreen() {
    return Container(
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
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                ),
                child: Text(
                  'Add New Items',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                onPressed: () {
                  takeImage(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(BuildContext mContext){
    return showDialog(context: mContext, builder: (context){
        return SimpleDialog(
          title: Text('Item Image', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
          children: [
            SimpleDialogOption(
              child: Text('Capture with Camera', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: Text('Select Image from Gallery', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              onPressed: selectImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text('Cancel', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        );
    });
  }


  void captureImageWithCamera() async{
    Navigator.pop(context);

    pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      imageFile = File(pickedFile.path);
    });

  }

  void selectImageFromGallery() async {
    Navigator.pop(context);
    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  void clearFormInfo() {
    setState(() {
      imageFile = null;
      descriptionTextEditingController.clear();
      priceTextEditingController.clear();
      shortInfoTextEditingController.clear();
      titleTextEditingController.clear();
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
    });
  }

  void uploadImageAndSaveItemInfo() async{
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadImage(imageFile);

    saveItemInfo(imageDownloadUrl);
  }

  saveItemInfo(String downloadUrl){

    final itemsRef = Firestore.instance.collection('items');

    itemsRef.document(productId).setData({
      "title": titleTextEditingController.text.trim(),
      "shortInfo": shortInfoTextEditingController.text.trim(),
      "longDescription": descriptionTextEditingController.text.trim(),
      "price": priceTextEditingController.text.trim(),
      "publishedDate": DateTime.now(),
      "thumbnailUrl": downloadUrl,
      "status": "available",
    });

    setState(() {
      clearFormInfo();
    });

  }

  Future<String> uploadImage(File tempImageFile) async {

    final StorageReference storageReference = FirebaseStorage.instance.ref().child('items');

    StorageUploadTask uploadTask = storageReference.child("product $productId.jpg").putFile(tempImageFile);

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    String downLoadUrl = await taskSnapshot.ref.getDownloadURL();

    return downLoadUrl;

  }


}


