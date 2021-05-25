import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getNutritionistList() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("role_id", isEqualTo: 2)
        .get();
  }

  getUserByusername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: username)
        .where("role_id", isEqualTo: 2)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatroom(String chatId, chatMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatId)
        .set(chatMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatId) async {
    return await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("chatroom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  getVideoCallChannel(String userName) async {
    return await FirebaseFirestore.instance
        .collection("call")
        .doc(userName)
        .snapshots();
  }
}
