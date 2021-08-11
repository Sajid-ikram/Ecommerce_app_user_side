import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_for_users/Screens/profile/profileProvider.dart';
import 'package:ecommerce_app_for_users/Screens/profile/selectImage.dart';
import 'package:ecommerce_app_for_users/Services/Authentication.dart';
import 'package:ecommerce_app_for_users/helperWidgets/appBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<String> items = [
    "Show payment details",
    "Payment history",
    "Explore new Product",
    "Statistic",
    "Log Out"
  ];
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: customAppBar("Profile", Color(0xff343A40)),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: size.height * 0.22,
                width: double.infinity,
                color: Color(0xff343A40),
              ),
              SizedBox(
                height: 70,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (ctx, index) {
                      return buildText(items[index]);
                    },
                  ),
                ),
              )
            ],
          ),
          buildProfilePart(size)
        ],
      ),
    );
  }

  Positioned buildProfilePart(Size size) {
    return Positioned(
      top: size.height * 0.035,
      left: size.width * 0.05,
      right: size.width * 0.05,
      child: Container(
        padding: EdgeInsets.all(5),
        height: size.height * 0.25,
        width: size.width * 0.71,
        decoration: BoxDecoration(
          color: Color(0xff343A40),
          boxShadow: [
            BoxShadow(
              color: Color(0xff222831).withOpacity(0.4),
              spreadRadius: 9,
              blurRadius: 9,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.16,
              width: size.height * 0.16,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    height: size.height * 0.15,
                    width: size.height * 0.15,
                    child: Consumer<ProfileProvider>(
                      builder: (context, provider, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: provider.profileUrl!= ""? FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'assets/profile.jpg',
                            image: provider.profileUrl,

                          ):Image.asset("assets/profile.jpg",fit: BoxFit.cover,),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    right: size.height * 0.015,
                    bottom: size.height * 0.015,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("selectImage");
                      },
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 18,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "Sajid ikram",
              style:
              GoogleFonts.poppins(color: Color(0xffFCCFA8), fontSize: 22),
            )
          ],
        ),
      ),
    );
  }

  Widget buildText(String text) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        if (text == "Log Out") {
          Provider.of<Authentication>(context, listen: false).signOut();
          Navigator.pop(context);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: 50,
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              child: text == "Log Out"
                  ? Icon(
                Icons.logout,
                color: Color(0xffFCCFA8),
              )
                  : Icon(
                Icons.star_border,
                color: Color(0xffFCCFA8),
              ),
              decoration: BoxDecoration(
                color: Color(0xff343A40),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 34),
              child: Text(text,
                  style:
                  GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
