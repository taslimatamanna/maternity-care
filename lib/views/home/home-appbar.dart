import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health_care/helper/authenticate.dart';
import 'package:health_care/services/auth-service/auth.dart';

AppBar homeAppbar(BuildContext context) {
  AuthMethods authMethods = new AuthMethods();
  return AppBar(
    backgroundColor: Color(0xffe3e3e3),
    elevation: 0,
    leading: IconButton(
      icon: FaIcon(
        FontAwesomeIcons.user,
        size: 22,
        color: Colors.pink[700],
      ),
      onPressed: null,
    ),
    actions: [
      GestureDetector(
        onTap: () {
          authMethods.signOut();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Authenticate()));
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.exit_to_app,
              size: 24,
              color: Colors.pink[700],
            ),
          ),
        ),
      )
    ],
  );
}
