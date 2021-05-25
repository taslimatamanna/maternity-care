import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_care/helper/constants.dart';
import 'package:health_care/helper/helper-funtion.dart';
import 'package:health_care/services/database/database.dart';
import 'package:health_care/views/call/call.dart';
import 'package:health_care/views/chatroom/conversation-screen.dart';
import 'package:health_care/widgets/card/card-item.dart';
import 'package:health_care/widgets/card/container-card.dart';
import 'package:permission_handler/permission_handler.dart';

class NutritionistProfile extends StatefulWidget {
  QuerySnapshot snapShotNutritionistInfo;
  NutritionistProfile({this.snapShotNutritionistInfo});
  @override
  _NutritionistProfileState createState() => _NutritionistProfileState();
}

class _NutritionistProfileState extends State<NutritionistProfile> {
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      Constants.myName.isEmpty ? _validateError = true : _validateError = false;
    });
    if (Constants.myName.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: "happ",
            role: ClientRole.Broadcaster,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPreference();
    print(Constants.myName);
  }

  startConversation() {
    String nutritionistName =
        widget.snapShotNutritionistInfo.docs[0].data()['name'];
    String chatRoomId = getChatRoomId(nutritionistName, Constants.myName);

    List<String> users = [nutritionistName, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId,
    };

    databaseMethods.createChatroom(chatRoomId, chatRoomMap);
    print(users);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(
                  nutritionistName: nutritionistName,
                  chatRoomId: chatRoomId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StackContainer(
              name: widget.snapShotNutritionistInfo.docs[0].data()['name'],
            ),
            SizedBox(
              height: 25,
            ),
            CardItem(
              text: "Start chat",
              cardIcon: Icons.message,
              onPressed: () {
                startConversation();
              },
            ),
            SizedBox(
              height: 12,
            ),
            CardItem(
              text: "Start face time",
              cardIcon: Icons.videocam,
              onPressed: () {
                print("start call");
                onJoin();
              },
            ),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
