import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/helper/constants.dart';
import 'package:health_care/helper/helper-funtion.dart';
import 'package:health_care/services/database/database.dart';
import 'package:health_care/views/chatroom/chat-list.dart';
import 'package:health_care/views/nutritionist/list.dart';
import 'package:health_care/views/nutritionist/searched-list.dart';
import 'package:health_care/views/web-views/baby-care.dart';
import 'package:health_care/views/web-views/safe-pregnancy.dart';
import './home-appbar.dart';
import 'package:health_care/services/auth-service/auth.dart';

class HomeView extends StatefulWidget {
  final User user;

  HomeView({this.user});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  TextEditingController searchTextController = TextEditingController();

  QuerySnapshot searchSnapshot;

  AuthMethods _auth = AuthMethods();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myRole = await HelperFunction.getUserRoleIdSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: homeAppbar(context),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xffe3e3e3),
          child: Column(
            children: [
              Container(
                width: size.width,
                height: 220,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width / 2 - 80,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            child: Text(
                              "Be Smart Mom",
                              style: TextStyle(
                                color: Colors.pink[800],
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "Manage the most perfect health & birth plan",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 210.0,
                      width: size.width / 2 + 50,
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/e-consultation.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("role Id#######");
                  print(Constants.myRole);
                  if (Constants.myRole == 2) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatList()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NutritionistList()));
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.pink[900],
                        Colors.pink[600],
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 160.0,
                        width: size.width / 2 - 25,
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/consultation.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: size.width / 2,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Consultation",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Meet the best Nutritionist and proper guideline",
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SafePregnancy()));
                    },
                    child: Container(
                      width: size.width / 2 - 25,
                      height: 200,
                      margin:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.pink[500],
                            Colors.pink[300],
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 150.0,
                            width: 170.0,
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/safe-pregnancy.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text(
                            "Safe Pregnancy",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BabyCare()));
                    },
                    child: Container(
                      width: size.width / 2 - 25,
                      height: 200,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.pink[300],
                            Colors.pink[500],
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 150.0,
                            width: 170.0,
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/babyCare.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Text(
                            "Baby Care",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
