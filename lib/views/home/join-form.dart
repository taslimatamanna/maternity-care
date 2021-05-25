import 'package:flutter/material.dart';
import 'package:health_care/helper/helper-funtion.dart';
import 'package:health_care/services/database/database.dart';
import 'package:health_care/views/home/home-view.dart';
import 'package:health_care/views/nutritionist/list.dart';
import 'package:health_care/widgets/input-field/input-decoration.dart';

class JoinForm extends StatefulWidget {
  @override
  _JoinFormState createState() => _JoinFormState();
}

class _JoinFormState extends State<JoinForm> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  String selectedRole = 'patient';
  int roleId = 1;

  joinUser(){
    if (formKey.currentState.validate()) {
      Map<String, dynamic> userInfoMap = {
          "name": usernameController.text,
          "email": emailController.text,
          "role_id": roleId,
        };
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunction.saveUserNameSharedPreference(usernameController.text);
        HelperFunction.saveUserEmailSharedPreference(emailController.text);
        HelperFunction.saveUserRoleIdSharedPreference(roleId);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomeView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    top: 40.0,
                    bottom: 10.0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/formImg.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Let's Get to know You",
                          style: TextStyle(
                            color: Colors.pink[700],
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
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
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Role: ',
                          style: inputTextstyle(),
                        ),
                        Radio(
                          value: 1,
                          groupValue: roleId,
                          onChanged: (val) {
                            setState(() {
                              selectedRole = 'patient';
                              roleId = 1;
                            });
                          },
                        ),
                        Text(
                          'patient',
                          style: inputTextstyle(),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Radio(
                          value: 2,
                          groupValue: roleId,
                          onChanged: (val) {
                            setState(() {
                              selectedRole = 'nutritionist';
                              roleId = 2;
                            });
                          },
                        ),
                        Text(
                          'nutritionist',
                          style: inputTextstyle(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    joinUser();
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
                      "Get Started",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
