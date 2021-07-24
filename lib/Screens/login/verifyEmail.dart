import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final auth = FirebaseAuth.instance;
  User? user;
  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    user = auth.currentUser;
    user!.sendEmailVerification();
    Timer.periodic(Duration(seconds: 3), (timer) {});
    super.initState();
  }

  Future<void> checkEmailVerification() async {
    user = auth.currentUser;
    await user!.reload();
    if(user!.emailVerified){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
