import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>

{

  final TextEditingController emailTextEditingController =
  TextEditingController();
  final TextEditingController passwordTextEditingController =
  TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: SizeConfig.fontSize * 40,
              height: SizeConfig.fontSize * 40,
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/login.png"),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Login to your account", style: TextStyle(color: Colors.white),),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    isObsecure: false,
                    controller: emailTextEditingController,
                    data: Icons.person,
                    hintText: "Email",
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

                    emailTextEditingController.text.isNotEmpty
                        && passwordTextEditingController.text.isNotEmpty
                        ? loginUser()
                        : displayError(message: "Please write email and password");

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
                Navigator.push(context, MaterialPageRoute(builder: (c) => AdminSignInPage()));
              },
              child: Text('Admin Login', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
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

  FirebaseAuth _auth = FirebaseAuth.instance;

  loginUser() async{
    displayError(message: "Authenticating, please wait..");

    FirebaseUser firebaseUser;

    await _auth.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim()).then((authUser){
          firebaseUser = authUser.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: error.message.toString());
          }
      );
    });

    if(firebaseUser != null) {
      readUserData(firebaseUser).then((value){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (context) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }

  }

  Future readUserData(FirebaseUser fUser) async {

    Firestore.instance.collection(AppConfig.collectionUser).document(fUser.uid).get().then((userDataSnapshot) async{
      await AppConfig.sharedPreferences.setString(AppConfig.userUID, userDataSnapshot.data[AppConfig.userUID]);
      await AppConfig.sharedPreferences.setString(AppConfig.userEmail, userDataSnapshot.data[AppConfig.userEmail]);
      await AppConfig.sharedPreferences.setString(AppConfig.userName, userDataSnapshot.data[AppConfig.userName]);
      await AppConfig.sharedPreferences.setString(AppConfig.userAvatarUrl, userDataSnapshot.data[AppConfig.userAvatarUrl]);

      List<String> cartList = userDataSnapshot.data[AppConfig.userCartList].cast<String>();

      await AppConfig.sharedPreferences.setStringList(AppConfig.userCartList, cartList);
    });

  }

}
