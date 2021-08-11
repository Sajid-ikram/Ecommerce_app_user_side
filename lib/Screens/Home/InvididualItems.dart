import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            return Center(child: CircularProgressIndicator(),);
          }

          final data = snapshot.data;

          return GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, childAspectRatio: 2 / 2),
              itemCount: data!.size,
              itemBuilder: (BuildContext context, int index) {
                return productCard(data, index);
              });
        },
      ),
    );
  }

  Widget productCard(QuerySnapshot<Object?> data, int index) {
    return InkWell(
      onTap: () {},
      child: Hero(
        tag: data.docs[index].id,
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.fromLTRB(2, 10, 15, 10),
          height: MediaQuery.of(context).size.height * 0.5,
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
                      padding: const EdgeInsets.fromLTRB(15,8,8,8),
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
                      onPressed: () {},
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
