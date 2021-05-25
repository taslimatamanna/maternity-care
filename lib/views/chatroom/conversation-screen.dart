import 'package:flutter/material.dart';
import 'package:health_care/helper/constants.dart';
import 'package:health_care/services/database/database.dart';

class ConversationScreen extends StatefulWidget {
  final String nutritionistName, chatRoomId;

  const ConversationScreen({
    this.nutritionistName,
    this.chatRoomId,
  });
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  TextEditingController messageTextController = TextEditingController();
  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapShot) {
        return snapShot.hasData
            ? ListView.builder(
                itemCount: snapShot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapShot.data.docs[index].data()["message"],
                    isSendByUser: snapShot.data.docs[index].data()['sendBy'] ==
                        Constants.myName,
                  );
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageTextController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageTextController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageTextController.text = "";
    }
  }

  @override
  void initState() {
    
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val){
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe3e3e3),
        title: Text(
          widget.nutritionistName,
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
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.pink[100],
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        style: TextStyle(color: Colors.pink[900], fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "write your message...",
                          hintStyle: TextStyle(color: Colors.pink[900]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
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
                          Icons.send,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByUser;
  MessageTile({
    this.message,
    this.isSendByUser,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isSendByUser
                  ? [Colors.pink[200], Colors.pink[100]]
                  : [Colors.pink[800], Colors.pink[900]]),
          borderRadius: isSendByUser
              ? BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSendByUser ? Colors.pink[900] : Colors.pink[50],
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
