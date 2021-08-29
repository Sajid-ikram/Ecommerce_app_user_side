import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_for_users/Screens/Home/homeController.dart';
import 'package:ecommerce_app_for_users/Services/cartNotificationProvider.dart';
import 'package:ecommerce_app_for_users/Services/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class IndividualItems extends StatefulWidget {
  const IndividualItems({Key? key}) : super(key: key);

  @override
  _IndividualItemsState createState() => _IndividualItemsState();
}

class _IndividualItemsState extends State<IndividualItems> {


  final Stream<QuerySnapshot> user =
      FirebaseFirestore.instance.collection("products").snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: StreamBuilder<QuerySnapshot>(
        stream: user,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data;

          return Consumer<HomeController>(
            builder: (context, provider, child) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (ctx, index) {
                  if (provider.pageNumber == 3) {
                    return productCard(data!, index);
                  } else if (data!.docs[index]["category"] ==
                      provider.titles[provider.pageNumber]) {
                    return productCard(data, index);
                  }

                  return SizedBox();
                },
                itemCount: data!.size,
              );
            },
          );
        },
      ),
    );
  }

  Widget productCard(QuerySnapshot<Object?> data, int index) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "productDetailPage",
            arguments: data.docs[index]);
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Hero(
        tag: data.docs[index].id,
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.fromLTRB(0, 10, 15, 10),
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
                    //height: MediaQuery.of(context).size.height * 0.08,
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
                    child: RawMaterialButton(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addProductToCart(data.docs[index]);
                        Provider.of<CartNotificationProvider>(context, listen: false)
                            .checkIsCartEmpty("new");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Item is added to the cart'),
                            duration: Duration(seconds: 1),
                          ),
                        );
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
