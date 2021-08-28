import 'package:ecommerce_app_for_users/Screens/Home/InvididualItems.dart';
import 'package:ecommerce_app_for_users/Screens/Home/homeController.dart';
import 'package:ecommerce_app_for_users/Screens/Home/sideNevigationBar.dart';
import 'package:ecommerce_app_for_users/Services/cartNotificationProvider.dart';
import 'package:ecommerce_app_for_users/Services/profileProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(user!.uid);
    Provider.of<CartNotificationProvider>(context, listen: false)
        .checkIsCartEmpty("old");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          SideNavigationBar(),
          const VerticalDivider(thickness: 1, width: 1),
          buildItems(context)
        ],
      ),
    );
  }

  Expanded buildItems(BuildContext context) {
    final List<String> titles = [
      "Popular",
      "Fashion",
      "Electronics",
      "Furniture",
      "All"
    ];
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 0, 0),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            //physics: BouncingScrollPhysics(),
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: 37,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Color(0xffFCCFA8),
                    ),
                    onPressed: () {},
                  ),
                  Consumer<CartNotificationProvider>(
                    builder: (context, provider, child) {
                      return Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.shopping_cart_outlined,
                              color: Color(0xffFCCFA8),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "cartPage");
                            },
                          ),
                          if (!provider.isCartEmpty)
                            Positioned(
                              child: Container(
                                height: 8,
                                width: 8,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              top: 9,
                              right: 9,
                            )
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<HomeController>(
                builder: (context, provider, child) {
                  return Text(
                    titles[provider.pageNumber],
                    style: TextStyle(fontSize: 26, color: Color(0xffFCCFA8)),
                  );
                },
              ),
              const SizedBox(
                height: 5,
              ),
              IndividualItems()
            ],
          ),
        ),
      ),
    );
  }
}
