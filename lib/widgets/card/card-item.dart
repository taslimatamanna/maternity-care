import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String text;
  final Function onPressed;
  final IconData cardIcon;

  const CardItem({
    this.text,
    this.onPressed,
    this.cardIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 21.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  cardIcon,
                  size: 40.0,
                  color: Colors.pink[800],
                ),
                SizedBox(width: 24.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
