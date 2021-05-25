import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_care/services/auth-service/auth.dart';
import 'package:health_care/services/database/database.dart';
import 'package:health_care/views/chatroom/chat-list.dart';
import 'package:health_care/views/nutritionist/search.dart';
import 'package:health_care/widgets/list/list.dart';

class NutritionistList extends StatefulWidget {
  @override
  _NutritionistListState createState() => _NutritionistListState();
}

class _NutritionistListState extends State<NutritionistList> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot listItemSnapshot;

  getList() {
    databaseMethods.getNutritionistList().then((value) {
      setState(() {
        listItemSnapshot = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe3e3e3),
        title: Text(
          "Nutritionist",
          style: TextStyle(
            color: Colors.pink[900],
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ChatList()));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.message_rounded,
                  size: 24,
                  color: Colors.pink[900],
                ),
              ),
            ),
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.pink[900],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Colors.pink[900],
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      body: Container(
        child: listItemSnapshot != null
            ? searchList(context, listItemSnapshot)
            : Container(),
      ),
    );
  }
}
