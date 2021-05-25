import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:health_care/widgets/app-bar/top-bar.dart';
import 'package:health_care/widgets/custom-clipper/my-custom-clipper.dart';


class StackContainer extends StatelessWidget {
  final String name;
  const StackContainer({
    this.name
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Stack(
        children: <Widget>[
          Container(),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                      colors: [
                        Colors.pink[900],
                        Colors.pink[600],
                      ],
                    ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[                
                CircularProfileAvatar(
                  "https://webstockreview.net/images/clipart-doctor-primary-care-physician-12.png",
                  borderWidth: 4.0,
                  radius: 60.0,
                ),
                SizedBox(height: 4.0),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Nutritionist",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          TopBar(),
        ],
      ),
    );
  }
}