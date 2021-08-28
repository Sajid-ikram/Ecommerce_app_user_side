import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CartNotificationProvider extends ChangeNotifier {
  bool isCartEmpty = true;

  checkIsCartEmpty(String fromWhere) {
    if (fromWhere == "new" && isCartEmpty == false) {
    } else {
      final User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("cart")
          .limit(1)
          .get()
          .then(
        (value) {
          value.docs.length == 0 ? isCartEmpty = true : isCartEmpty = false;
          notifyListeners();
        },
      );
    }
  }
}
