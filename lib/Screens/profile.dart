import 'package:ecommerce_app_for_users/Services/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ff"),),
      body: Center(
        child: OutlinedButton(
          onPressed: (){
            Provider.of<Authentication>(context, listen: false).signOut();
            Navigator.pop(context);
          },
          child: Text("f"),
        ),
      ),
    );
  }
}
