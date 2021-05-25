import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_care/services/database/database.dart';
import 'package:health_care/views/nutritionist/nutritionist-profile.dart';

class ListItem extends StatefulWidget {
  final String userName;
  final String userEmail;
  ListItem({this.userName, this.userEmail});

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapShotNutritionistInfo;
  openNutritionistProfile() {
    databaseMethods.getUserByUserEmail(widget.userEmail).then((val) {
      snapShotNutritionistInfo = val;
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => NutritionistProfile(
          snapShotNutritionistInfo: snapShotNutritionistInfo,
        )));
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      child: Row(
        children: [
          Text(
            widget.userName,
            style: TextStyle(
              color: Colors.pink[900],
              fontSize: 20,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              openNutritionistProfile();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.pink[900],
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
