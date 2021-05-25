import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/services/auth-service/auth.dart';
import 'package:health_care/services/database/database.dart';
import 'package:health_care/views/home/join-form.dart';
import 'package:health_care/widgets/input-field/input-decoration.dart';

enum MobileVerificationState { SHOW_MOBILE_FORM_STATE, SHOW_OTP_FORM_STATE }

class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController otpController = TextEditingController();

  String verificationId;
  bool showLoading = false;

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential?.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => JoinForm()));
      }
    } catch (e) {
      setState(() {
        showLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), duration: Duration(seconds: 4)));
    }
  }

  getMobileFormWidget(context) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Phone Verification",
                style: TextStyle(
                  color: Colors.pink[700],
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      return value.isEmpty || value.length < 11
                          ? "enter your 11digits phone number"
                          : null;
                    },
                    controller: phoneNumberController,
                    style: inputTextstyle(),
                    decoration: textFieldInputDecoration("phone number"),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                showLoading = true;
              });
              await _auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                timeout: Duration(seconds: 60),
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                },
                verificationFailed: (verificationFailed) async {
                  print(verificationFailed.message);
                  setState(() {
                    showLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(verificationFailed.message),
                      duration: Duration(seconds: 4)));
                },
                codeSent: (verificationId, [resendingToken]) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId = verificationId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pink[900],
                    Colors.pink[700],
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "Send",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getOtpFormWidget(context) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "OTP Verification",
                style: TextStyle(
                  color: Colors.pink[700],
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      return value.isEmpty ? "enter OTP code" : null;
                    },
                    controller: otpController,
                    style: inputTextstyle(),
                    decoration: textFieldInputDecoration("enter OTP"),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () async {
              AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: otpController.text);
              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pink[900],
                    Colors.pink[700],
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "Verify",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: showLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 30.0,
                          bottom: 20.0,
                        ),
                        child: Container(
                          height: 120.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/momCare.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      (currentState ==
                              MobileVerificationState.SHOW_MOBILE_FORM_STATE)
                          ? getMobileFormWidget(context)
                          : getOtpFormWidget(context)
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
