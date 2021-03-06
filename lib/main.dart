import 'package:ecommerce_app_for_users/Screens/Home/homeController.dart';
import 'package:ecommerce_app_for_users/Screens/cart/cartScreen.dart';
import 'package:ecommerce_app_for_users/Screens/login/signInAndLogin.dart';
import 'package:ecommerce_app_for_users/Services/cartNotificationProvider.dart';
import 'package:ecommerce_app_for_users/Services/cartProvider.dart';
import 'package:ecommerce_app_for_users/Services/warning.dart';
import 'package:ecommerce_app_for_users/Screens/product/productDetailPage.dart';
import 'package:ecommerce_app_for_users/Screens/profile/profile.dart';
import 'package:ecommerce_app_for_users/Services/profileProvider.dart';
import 'package:ecommerce_app_for_users/Screens/profile/selectImage.dart';
import 'package:ecommerce_app_for_users/Services/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Screens/Home/Home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => Warning()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CartNotificationProvider()),
      ],
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          accentColor: Colors.white10,
         /* textTheme: TextTheme(
              headline4: TextStyle(color: Color(0xffFCCFA8), fontSize: 27)),*/
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
              //headline4: TextStyle(color: Color(0xffFCCFA8), fontSize: 27)
          ),
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xff28292E),
        ),
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Exception(
                massage: "Error",
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return MiddleOfHomeAndSignIn();
            }

            return Exception(
              massage: "Loading",
            );
          },
        ),
        routes: {
          "profile": (ctx) => Profile(),
          "selectImage": (ctx) => SelectImage(),
          "productDetailPage": (ctx) => ProductDetailPage(),
          "cartPage": (ctx) => CartScreen(),
        },
      ),
    );
  }
}

class Exception extends StatelessWidget {
  const Exception({Key? key, required this.massage}) : super(key: key);
  final String massage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: massage == "Error"
            ? Text("An error occur")
            : CircularProgressIndicator(),
      ),
    );
  }
}

class MiddleOfHomeAndSignIn extends StatefulWidget {
  const MiddleOfHomeAndSignIn({Key? key}) : super(key: key);

  @override
  _MiddleOfHomeAndSignInState createState() => _MiddleOfHomeAndSignInState();
}

class _MiddleOfHomeAndSignInState extends State<MiddleOfHomeAndSignIn> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: Provider.of<Authentication>(context).authStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xffFCCFA8)),
          );
        }
        return snapshot.data == null ? SignInAndSignUp() : Home();
      },
    );
  }
}
