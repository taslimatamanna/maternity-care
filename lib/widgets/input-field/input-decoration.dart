import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.pink[900]
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.pink[900])
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.pink[900]),
    )
  );
}

TextStyle inputTextstyle(){
  return TextStyle(
    color: Colors.pink[900],
    fontSize: 18,
  );
}