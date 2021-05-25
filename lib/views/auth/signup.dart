import 'package:flutter/material.dart';
import 'package:health_care/helper/helper-funtion.dart';
import 'package:health_care/services/auth-service/auth.dart';
import 'package:health_care/services/database/database.dart';
import 'package:health_care/views/auth/phone-login.dart';
import 'package:health_care/views/home/join-form.dart';
import 'package:health_care/views/nutritionist/list.dart';
import 'package:health_care/widgets/input-field/input-decoration.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isLoading = false;
  String selectedRole = 'patient';
  int roleId = 1;

  signUpUser() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      )
          .then((value) {
        //print("${value.userId}");
        // Map<String, dynamic> userInfoMap = {
        //   "name": usernameController.text,
        //   "email": emailController.text,
        //   "role_id": roleId,
        // };
        // databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunction.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => JoinForm()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 50.0,
                          bottom: 20.0,
                        ),
                        child: Container(
                          height: 80.0,
                          width: 80.0,
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
                                return value.isEmpty || value.length < 2
                                    ? "username must have atleast 3 characters"
                                    : null;
                              },
                              controller: usernameController,
                              style: inputTextstyle(),
                              decoration: textFieldInputDecoration("username"),
                            ),
                            SizedBox(
                              height: 5,
                            ),
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
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          signUpUser();
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
                            "Sign Up",
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhoneLogin()));
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
                            "Sign up with Phone",
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
                            "Already have an account? ",
                            style: inputTextstyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              child: Text(
                                " SignIn now",
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
