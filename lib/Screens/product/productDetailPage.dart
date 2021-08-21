import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: size.height * 1.34,
          width: size.width,
          child: Stack(
            children: [
              Stack(
                children: [
                  Container(
                    height: size.height * 0.6,
                    width: size.width,
                    color: Colors.red,
                    child: Hero(
                      tag: args.id,
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: 'assets/profile.jpg',
                        image: args["url"],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                          Navigator.of(context).pop();
                        },
                      child: Container(
                        height: 33,
                        width: 33,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                              Icons.arrow_back,
                              size: 17,
                            ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: size.height * 0.56,
                child: buildProductInfo(size, args),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildProductInfo(Size size, DocumentSnapshot args) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: Color(0xff28292E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(args["name"],
                    style: TextStyle(fontSize: 25, color: Colors.white)),
                Text("\$ ${args["price"]}".toString(),
                    style: TextStyle(fontSize: 25, color: Colors.white)),
              ],
            ),
            Divider(
              thickness: 2,
              color: Colors.white,
              endIndent: 40,
              indent: 40,
              height: 60,
            ),
            Text("Product details : ".toString(),
                style: TextStyle(fontSize: 23, color: Color(0xffFCCFA8))),
            SizedBox(
              height: 10,
            ),
            Text(
                "In marketing, a product is an object or system made available for consumer use;"
                " it is anything that can be offered to a market to satisfy the desire or need"
                " of a customer. In retailing, products are often referred to as merchandise,"
                " and in manufacturing, products are bought as raw materials and then sold as finished "
                "goods. A service is also regarded to as a type of product",
                style: TextStyle(fontSize: 16, color: Colors.white)),
            InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 50,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffFCCFA8),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text("Add To Cart".toString(),
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
