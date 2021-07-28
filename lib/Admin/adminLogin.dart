import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        title: Text(AppConfig.appName,
          style: TextStyle(
            fontSize: SizeConfig.fontSize * 10,
            color: Colors.white,
            fontFamily: AppFont.appFont,
          ),),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{

  final TextEditingController adminIdTextEditingController =
  TextEditingController();
  final TextEditingController passwordTextEditingController =
  TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppConfig.primaryColor, AppConfig.secondaryColor],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: SizeConfig.fontSize * 40,
              height: SizeConfig.fontSize * 40,
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/admin.png"),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Login to your admin account", style: TextStyle(color: Colors.white),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    isObsecure: false,
                    controller: adminIdTextEditingController,
                    data: Icons.person,
                    hintText: "Admin ID",
                  ),

                  CustomTextField(
                    isObsecure: false,
                    controller: passwordTextEditingController,
                    data: Icons.email,
                    hintText: "Password",
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 6,
              width: SizeConfig.blockSizeHorizontal * 40,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {

                    adminIdTextEditingController.text.isNotEmpty
                        && passwordTextEditingController.text.isNotEmpty
                        ? loginAdmin()
                        : displayError(message: "Please write Admin ID and password");

                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),
            Container(
              height: 4.0,
              width: SizeConfig.screenWidth * 0.8,
              color: Colors.pink,
            ),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (c) => AuthenticScreen()));
              },
              child: Text('User Login', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  displayError({String message}) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: message,
          );
        });
  }

  loginAdmin() async {
    Firestore.instance.collection('admins').getDocuments().then((snap){
      snap.documents.forEach((result) {
        if(result['id'] != adminIdTextEditingController.text){
          Fluttertoast.showToast(
              msg: "ID is incorrect",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        } else if(result['password'] != passwordTextEditingController.text){
          Fluttertoast.showToast(
              msg: "Password is incorrect",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        } else {
          Route route = MaterialPageRoute(builder: (context) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });


  }

}
