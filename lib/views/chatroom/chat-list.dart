import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:health_care/helper/constants.dart';
import 'package:health_care/helper/helper-funtion.dart';
import 'package:health_care/services/database/database.dart';
import 'package:health_care/views/call/call.dart';
import 'package:health_care/views/chatroom/conversation-screen.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final _channelController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream chatListStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatListStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.docs[index]
                        .data()['chatroomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.docs[index].data()["chatroomId"],
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPreference();
    print(Constants.myName);
    DatabaseMethods().getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatListStream = val;
        //print("Got data + ${chatListStream.toString()}");
      });
    });
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      Constants.myName.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (Constants.myName.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: "tat",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe3e3e3),
        title: Text(
          "Messages",
          style: TextStyle(
            color: Colors.pink[900],
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.pink[900],
        ),
        actions: [
          (Constants.myRole == 2) ?
          GestureDetector(
            onTap: () {
              onJoin();
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.camera_alt,
                  size: 24,
                  color: Colors.pink[900],
                ),
              ),
            ),
          ): Container()
        ],
      ),
      body: Container(
        child: chatRoomList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                      nutritionistName: userName,
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.pink[100],
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.pink[800],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                userName.substring(0, 1),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              userName,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.pink[800],
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
