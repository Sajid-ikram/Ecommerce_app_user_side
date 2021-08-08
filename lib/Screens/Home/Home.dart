import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_for_users/Screens/Home/InvididualItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  var padding = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    minWidth: 56.0,
                    groupAlignment: 1.0,
                    backgroundColor: Color(0xff2D3035),
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.all,
                    leading: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 53,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("profile");
                          },
                          child: Center(
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                  "https://upload.wikimedia.org/wikipedia/en/thumb/d/d9/Elizabeth_Olsen_as_Wanda_Maximoff.jpg/220px-Elizabeth_Olsen_as_Wanda_Maximoff.jpg"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: IconButton(
                            icon: Icon(Icons.tune),
                            color: Color(0xffFCCFA8),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                    selectedLabelTextStyle: TextStyle(
                      color: Color(0xffFCCFA8),
                      fontSize: 13,
                      letterSpacing: 0.8,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2.0,
                    ),
                    unselectedLabelTextStyle: TextStyle(
                        fontSize: 13, letterSpacing: 0.8, color: Colors.white),
                    destinations: [
                      buildRotatedTextRailDestination("Popular", padding),
                      buildRotatedTextRailDestination("Fashion", padding),
                      buildRotatedTextRailDestination("Electronics", padding),
                      buildRotatedTextRailDestination("Furniture", padding),
                      buildRotatedTextRailDestination("All", padding),
                    ],
                  ),
                ),
              ),
            );
          }),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
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
        padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
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
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                titles[_selectedIndex],
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 20,
              ),
              IndividualItems()
            ],
          ),
        ),
      ),
    );
  }

  NavigationRailDestination buildRotatedTextRailDestination(
      String text, double padding) {
    return NavigationRailDestination(
      icon: SizedBox.shrink(),
      label: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: RotatedBox(
          quarterTurns: -1,
          child: Text(text),
        ),
      ),
    );
  }
}
