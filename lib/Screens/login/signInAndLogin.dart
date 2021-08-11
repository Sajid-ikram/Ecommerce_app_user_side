import 'package:ecommerce_app_for_users/Screens/login/ErrorDialog.dart';
import 'package:ecommerce_app_for_users/Screens/login/warning.dart';
import 'package:ecommerce_app_for_users/Services/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignInAndSignUp extends StatefulWidget {
  @override
  _SignInAndSignUpState createState() => _SignInAndSignUpState();
}

class _SignInAndSignUpState extends State<SignInAndSignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  bool isVerified = false;
  bool isLoading = false;
  bool _isSignUp = false;
  final _emailKey = GlobalKey<FormState>();
  final _otpKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    otpController.clear();
    super.dispose();
  }

  validate() async {
    if (_isSignUp) {
      if (_passKey.currentState!.validate() &&
          _emailKey.currentState!.validate() &&
          _nameKey.currentState!.validate()) {
        buildShowDialog(context);

        Provider.of<Authentication>(context, listen: false)
            .sendOtp(emailController.text)
            .then(
          (value) {
            Navigator.of(context, rootNavigator: true).pop();

            if (value != "ok") {
              Provider.of<Warning>(context, listen: false)
                  .showWarning(value, Colors.amber, true);
            } else {
              _showMyDialog().then(
                (value) {
                  if (isVerified) {
                    buildShowDialog(context);
                    Provider.of<Authentication>(context, listen: false)
                        .signUp(emailController.text, passwordController.text,
                            nameController.text)
                        .then((value) {
                      Navigator.of(context, rootNavigator: true).pop();
                      if (value != "Success") {
                        Provider.of<Warning>(context, listen: false)
                            .showWarning(value, Colors.amber, true);
                      }
                    });
                  } else {
                    Provider.of<Warning>(context, listen: false).showWarning(
                        "Unsuccessful verification", Colors.amber, true);
                  }
                },
              );
            }
          },
        );
      }
    } else {
      if (_passKey.currentState!.validate() &&
          _emailKey.currentState!.validate()) {
        buildShowDialog(context);
        Provider.of<Authentication>(context, listen: false)
            .signIn(emailController.text, passwordController.text)
            .then((value) {
            Navigator.of(context, rootNavigator: true).pop();
            if (value != "Success") {
              Provider.of<Warning>(context, listen: false)
                  .showWarning(value, Colors.amber, true);
            }
          },
        );
      }
    }
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xffFCCFA8)),
          );
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2B2B2B),
          title: Text('Enter Verification Code',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 15)),
          content: SingleChildScrollView(
            child: Form(
              key: _otpKey,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: otpController,
                validator: (value) {
                  return value == null || value.isEmpty
                      ? "Enter the otp"
                      : null;
                },
                keyboardType: TextInputType.name,
                decoration: buildInputDecoration("Code"),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onPressed: () {
                otpController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Verify',
                style: GoogleFonts.poppins(color: Colors.green),
              ),
              onPressed: () {
                if (_otpKey.currentState!.validate()) {
                  isVerified =
                      Provider.of<Authentication>(context, listen: false)
                          .verify(emailController.text, otpController.text);

                  if (!isVerified) {
                    Provider.of<Warning>(context, listen: false).showWarning(
                        "Invalid Verification Code", Colors.amber, true);
                  } else {
                    isVerified = true;
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B2B),
      appBar: AppBar(
        title: Text(
          "Ecommerce",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.20),
                        Form(
                          key: _emailKey,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            autofillHints: [AutofillHints.email],
                            controller: emailController,
                            validator: (value) {
                              return value == null || value.isEmpty
                                  ? "Enter a Email"
                                  : value.contains('@') &&
                                          value.contains('.com')
                                      ? null
                                      : "Enter a valid email";
                            },
                            keyboardAppearance: Brightness.light,
                            keyboardType: TextInputType.emailAddress,
                            decoration: buildInputDecoration("Email"),
                          ),
                        ),
                        SizedBox(height: 10),
                        if (_isSignUp)
                          Form(
                            key: _nameKey,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: nameController,
                              validator: (value) {
                                return value == null || value.isEmpty
                                    ? "Enter your name"
                                    : null;
                              },
                              keyboardType: TextInputType.name,
                              decoration: buildInputDecoration("Name"),
                            ),
                          ),
                        if (_isSignUp) SizedBox(height: 10),
                        Form(
                          key: _passKey,
                          child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: passwordController,
                              obscureText: true,
                              validator: (value) {
                                return value == null || value.isEmpty
                                    ? "Enter a Password"
                                    : value.length < 6
                                        ? "Length should be more than 6"
                                        : null;
                              },
                              decoration: buildInputDecoration("Password")),
                        ),
                        SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            validate();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffFCCFA8),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              _isSignUp ? "Sign Up" : "Sign In",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Color(0xff2B2B2B)),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _isSignUp
                                  ? "Already have an account ? "
                                  : "Don't have an account ? ",
                              style: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSignUp = !_isSignUp;
                                });
                              },
                              child: Text(
                                _isSignUp ? "Sign In" : "Sign Up",
                                style: GoogleFonts.poppins(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15,
                                  color: Color(0xffFCCFA8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
                ErrorDialog(),
              ],
            ),
    );
  }

  InputDecoration buildInputDecoration(String text) {
    return InputDecoration(
      filled: true,
      fillColor: Color(0xff444444),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.transparent,
          )),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.transparent,
          )),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.transparent,
          )),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.transparent,
          )),
      hintText: text,
      hintStyle: GoogleFonts.poppins(color: Colors.white),
    );
  }
}
