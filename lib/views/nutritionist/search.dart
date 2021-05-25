import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_care/services/database/database.dart';
import 'package:health_care/widgets/list/list.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextController = TextEditingController();
  QuerySnapshot searchSnapshot;


  searchNow() {
    databaseMethods.getUserByusername(searchTextController.text).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  startConversation(){
    // List<String> users = [];
    // databaseMethods.createChatroom(chatId, chatMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe3e3e3),
        title: Text(
          "Search",
          style: TextStyle(
            color: Colors.pink[900],
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.pink[900],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.pink[100],
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextController,
                      style: TextStyle(color: Colors.pink[900], fontSize: 18),
                      decoration: InputDecoration(
                        hintText: "enter nutritionist name...",
                        hintStyle: TextStyle(color: Colors.pink[900]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      searchNow();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.pink[50],
                            Colors.pink[200],
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.search,
                      ),
                    ),
                  )
                ],
              ),
            ),
            searchSnapshot != null
                ? searchList(context, searchSnapshot)
                : Container()
          ],
        ),
      ),
    );
  }
}
