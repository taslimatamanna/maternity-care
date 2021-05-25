import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_care/widgets/list/list.dart';

class SearchedList extends StatelessWidget {
  QuerySnapshot searchedList;

  SearchedList({this.searchedList});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe3e3e3),
        title: Text(
          "Searched Nutritionist",
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
        child: searchList(context, searchedList),
      ),
    );
  }
}