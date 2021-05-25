import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_care/helper/authenticate.dart';
import 'package:health_care/helper/helper-funtion.dart';
import 'package:health_care/views/home/home-view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;
  @override
  void initState() {
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunction.getUserLoggedInSharedPreference()
        .then((value) => userIsLoggedIn = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Health Care',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffe3e3e3),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: InitializeUser());
  }
}

class InitializeUser extends StatefulWidget {
  @override
  _InitializeUserState createState() => _InitializeUserState();
}

class _InitializeUserState extends State<InitializeUser> {
  FirebaseAuth _auth;
  User _user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _user == null
            ? Authenticate()
            : HomeView();
  }
}
