import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_for_users/Services/cartNotificationProvider.dart';
import 'package:ecommerce_app_for_users/Services/cartProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<CartProvider>(context, listen: false);

    final User? user = FirebaseAuth.instance.currentUser;
    final Stream<QuerySnapshot> productsCart = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("cart")
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff28292E),
        title: Text(
          "Cart",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            pro.updateChanges(user);
            Provider.of<CartNotificationProvider>(context, listen: false)
                .checkIsCartEmpty("old");
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsCart,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          final data = snapshot.data;

          for (int i = 0; i < data!.size; i++) {
            pro.cartAmounts.insert(i, int.parse(data.docs[i]["amount"]));
            pro.didCartAmountsChange.add(false);
            pro.cartProductId.add(data.docs[i].id);
          }

          return data.size == 0
              ? emptyCart()
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return cardProduct(data, index, pro, user);
                  },
                  itemCount: data.size,
                );
        },
      ),
    );
  }

  Widget emptyCart() {
    return Center(
      child: Text("Empty cart",style: TextStyle(color: Colors.white),),
    );
  }

  Widget cardProduct(
      QuerySnapshot data, int index, CartProvider pro, User user) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(data.docs[index]["url"]),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.docs[index]["name"],
                        style: GoogleFonts.poppins(
                            color: Color(0xFF628395), fontSize: 14),
                      ),

                      Text("\$${data.docs[index]["price"].toString()}",
                          style: GoogleFonts.poppins(
                              color: Color(0xFF628395),
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      //SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Row(
                  children: [
                    RawMaterialButton(
                      onPressed: () {
                        pro.decreaseCartAmount(index, user);
                      },
                      elevation: 0,
                      constraints: BoxConstraints(
                        minWidth: 0,
                      ),
                      shape: CircleBorder(),
                      fillColor: Color(0xffec6813),
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.remove, size: 16, color: Colors.white),
                    ),
                    Consumer<CartProvider>(
                      builder: (context, provider, child) {
                        return Text(provider.cartAmounts[index].toString());
                      },
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        pro.increaseCartAmount(index);
                      },
                      elevation: 0,
                      constraints: BoxConstraints(
                        minWidth: 0,
                      ),
                      shape: CircleBorder(),
                      fillColor: Color(0xffec6813),
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.add, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
