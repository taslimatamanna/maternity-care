import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_care/helper/constants.dart';
import 'package:health_care/helper/helper-funtion.dart';
import 'package:health_care/services/auth-service/auth.dart';
import 'package:health_care/services/database/database.dart';
import 'package:health_care/views/auth/phone-login.dart';
import 'package:health_care/views/home/home-view.dart';
import 'package:health_care/widgets/input-field/input-decoration.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapShotUserInfo;

  signInUser(){
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      databaseMethods.getUserByUserEmail(emailController.text).then((val){
        snapShotUserInfo = val;
        print(snapShotUserInfo.docs[0].data()['role_id']);
        HelperFunction.saveUserEmailSharedPreference(snapShotUserInfo.docs[0].data()['email']);
        HelperFunction.saveUserNameSharedPreference(snapShotUserInfo.docs[0].data()['name']);
        HelperFunction.saveUserRoleIdSharedPreference(snapShotUserInfo.docs[0].data()['role_id']);
      });



      authMethods
          .signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      )
          .then((value) async {
        //print("${value.userId}");
        if (value != null) {
          HelperFunction.saveUserLoggedInSharedPreference(true);
          Constants.myRole = await HelperFunction.getUserRoleIdSharedPreference();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeView()));
        }
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(vertical: 35),
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 70.0,
                    bottom: 20.0,
                  ),
                  child: Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/momCare.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)
                              ? null
                              : "enter a valid email";
                        },
                        controller: emailController,
                        style: inputTextstyle(),
                        decoration: textFieldInputDecoration("email"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.length > 6
                              ? null
                              : "enter a six character password";
                        },
                        controller: passwordController,
                        style: inputTextstyle(),
                        decoration: textFieldInputDecoration("password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   alignment: Alignment.centerRight,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //     child: Text(
                //       "Foraget Password",
                //       style: inputTextstyle(),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    signInUser();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.pink[900],
                          Colors.pink[700],
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PhoneLogin()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.pink[700],
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Sign in with Phone",
                      style: TextStyle(
                        color: Colors.pink[900],
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have Account? ",
                      style: inputTextstyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        child: Text(
                          " Register now",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
