import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar customAppBar(String text,Color color){
  return AppBar(
    centerTitle: true,
    elevation: 0,
    backgroundColor: color,
    title: Text(text,
        style: GoogleFonts.poppins(
          color: Colors.white,
        )),
  );
}