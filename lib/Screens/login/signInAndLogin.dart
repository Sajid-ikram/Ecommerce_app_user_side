
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

  validate() {
    if (_isSignUp) {
      if (!isVerified) {
        Provider.of<Warning>(context, listen: false)
            .showWarning("Please verify email first", Colors.amber, true);
      } else {
        if (_passKey.currentState!.validate() &&
            _emailKey.currentState!.validate() &&
            _nameKey.currentState!.validate()) {
          Provider.of<Authentication>(context, listen: false)
              .signUp(emailController.text, passwordController.text, nameController.text )
              .then((value) {

            if (value != "Success") {
              Provider.of<Warning>(context, listen: false)
                  .showWarning(value, Colors.amber, true);
            }
          });
        }
      }
    } else {
      if (_passKey.currentState!.validate() &&
          _emailKey.currentState!.validate()) {
        Provider.of<Authentication>(context, listen: false)
            .signIn(emailController.text, passwordController.text)
            .then(
          (value) {
            if (value != "Success") {
              Provider.of<Warning>(context, listen: false)
                  .showWarning(value, Colors.amber, true);
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff334756),
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
                          height: _isSignUp
                              ? MediaQuery.of(context).size.height * 0.14
                              : MediaQuery.of(context).size.height * 0.22,
                        ),
                        Form(
                          key: _emailKey,
                          child: TextFormField(
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
                            keyboardType: TextInputType.emailAddress,
                            decoration: buildInputDecoration("Email"),
                          ),
                        ),
                        if (_isSignUp)
                          InkWell(
                            onTap: () {
                              if (_emailKey.currentState!.validate()) {
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .sendOtp(emailController.text)
                                    .then((value) {
                                  if (value != "ok") {
                                    Provider.of<Warning>(context, listen: false)
                                        .showWarning(value, Colors.amber, true);
                                  } else {
                                    Provider.of<Warning>(context, listen: false)
                                        .showWarning('Verification Code Sent',
                                            Colors.green, true);
                                  }
                                });
                              }
                            },
                            child: Container(
                              child: Text(
                                "Send Verification Code  ",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Color(0xFF628395)),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        if (_isSignUp)
                          Form(
                            key: _otpKey,
                            child: TextFormField(
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
                        if (_isSignUp)
                          InkWell(
                            onTap: () {
                              if (_otpKey.currentState!.validate() &&
                                  _emailKey.currentState!.validate()) {
                                isVerified = Provider.of<Authentication>(
                                        context,
                                        listen: false)
                                    .verify(emailController.text,
                                        otpController.text);

                                if (!isVerified) {
                                  Provider.of<Warning>(context, listen: false)
                                      .showWarning("Invalid Verification Code",
                                          Colors.amber, true);
                                } else {
                                  Provider.of<Warning>(context, listen: false)
                                      .showWarning("Verification Confirmed",
                                          Colors.green, true);
                                }
                              }
                            },
                            child: Container(
                              child: Text(
                                "Confirm Code  ",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Color(0xFF628395)),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        if (!_isSignUp) SizedBox(height: 10),
                        if (_isSignUp)
                          Form(
                            key: _nameKey,
                            child: TextFormField(
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
                              color: Color(0xFF628395),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              _isSignUp ? "Sign Up" : "Sign In",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.white),
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
                              style: GoogleFonts.poppins(fontSize: 15),
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
                                  color: Color(0xFF628395),
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
      fillColor: Color(0xffDEEDF0),
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
      hintStyle: GoogleFonts.poppins(),
    );
  }
}
