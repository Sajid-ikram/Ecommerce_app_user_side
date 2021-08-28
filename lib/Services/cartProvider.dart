import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  List<int> cartAmounts = [];
  List<bool> didCartAmountsChange = [];
  List<String> cartProductId = [];

  void increaseCartAmount(int index) {
    cartAmounts[index]++;
    didCartAmountsChange[index] = true;
    notifyListeners();
  }

  Future<void> decreaseCartAmount(int index,User user) async {

    if (cartAmounts[index] > 1) {
      cartAmounts[index]--;
      didCartAmountsChange[index] = true;
      notifyListeners();
    } else {
      await updateChanges(user);
      try {
        didCartAmountsChange[index] = false;
        FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("cart")
            .doc(cartProductId[index])
            .delete();
        cartAmounts.clear();
        didCartAmountsChange.clear();
        cartProductId.clear();
      } catch (e) {}
    }
  }

  Future<void> updateChanges(User user) async {
    try {
      for (int i = 0; i < cartAmounts.length; i++) {
        if(didCartAmountsChange[i]){
          FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection("cart")
              .doc(cartProductId[i])
              .update({"amount": cartAmounts[i].toString()});
        }
      }
    } catch (e) {}
  }

  void addProductToCart(QueryDocumentSnapshot product) async {
    try {

      final User? user = FirebaseAuth.instance.currentUser;

      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("cart")
          .doc(product.id)
          .set(
        {
          "name": product['name'],
          "price": product['price'],
          "url": product['url'],
          "amount": "1"
        },
      );
    } catch (e) {}
  }
}
