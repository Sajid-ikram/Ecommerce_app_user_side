import 'package:flutter/cupertino.dart';

class HomeController extends ChangeNotifier{
  int pageNumber = 3;

  final List<String> titles = [
    "Fashion",
    "Electronics",
    "Furniture",
    "All"
  ];

  changeIndex(int index){
    pageNumber = index;
    notifyListeners();
  }

}