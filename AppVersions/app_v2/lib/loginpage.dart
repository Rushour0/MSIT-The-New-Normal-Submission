import 'loadScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Login page of the app
class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

// Making state for class LoginPage
class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: Color(0xFFbdc6cf));

  late bool _isHidden;
  late Icon visibilityIcon;
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final spinkit = SpinKitFoldingCube(
    duration: Duration(seconds: 10),
    color: Colors.red,
  );

  @override
  void initState() {
    _isHidden = true;
    visibilityIcon = Icon(Icons.visibility);
    super.initState();
  }

  changeHidden() {
    String temp = "";
    TextSelection tempPos = TextSelection.fromPosition(
        TextPosition(offset: _passwordTextController.text.length));
    setState(() {
      temp = _passwordTextController.text;
      _isHidden = !_isHidden;
      _passwordTextController.text = temp;
      _passwordTextController.selection = tempPos;
      if (_isHidden)
        visibilityIcon = Icon(
          Icons.visibility,
          color: Colors.blue.shade300,
        );
      else
        visibilityIcon = Icon(
          Icons.visibility_off,
          color: Colors.blue.shade300,
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: screenHeight * 3 / 10,
        title: Container(
          height: screenHeight * 3 / 10,
          width: screenWidth,
          child: Center(
            child: Container(
              height: screenHeight / 6,
              child: Image.asset(
                "img/main_icon.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenHeight / 15),
                    bottomRight: Radius.circular(screenHeight / 15),
                  ),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(screenHeight / 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: screenHeight / 20,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: "Bebas Neue",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: screenHeight / 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 16),
                              color: Colors.blueAccent.withOpacity(0.8),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(screenHeight / 30),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 30,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                  screenWidth / 50,
                                  screenHeight / 50,
                                  screenWidth / 50,
                                  screenHeight / 50),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(
                                      Icons.account_circle,
                                      color: Colors.grey,
                                    ),
                                    title: TextField(
                                      obscureText: false,
                                      controller: _usernameTextController,
                                      decoration: InputDecoration(
                                        filled: false,
                                        hintText: "Username",
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                        errorText: null,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade400,
                                    indent: screenWidth / 40,
                                    endIndent: screenWidth / 40,
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                    trailing: InkWell(
                                      child: visibilityIcon,
                                      onTap: () {
                                        changeHidden();
                                      },
                                    ),
                                    title: TextField(
                                      obscureText: _isHidden,
                                      controller: _passwordTextController,
                                      decoration: InputDecoration(
                                        filled: false,
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                        errorText: null,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: screenHeight / 15,
                      ),
                      Container(
                        height: screenHeight / 12.5,
                        width: screenWidth,
                        child: Material(
                          shadowColor: Colors.blue,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth / 20),
                          ),
                          child: InkWell(
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.circular(screenWidth / 20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight / 50),
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontFamily: "Bebas Neue",
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoadScreen(
                                        name: _usernameTextController.text,
                                        pass: _passwordTextController.text);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeartRateData {
  HeartRateData(this.HeartRate, this.time);
  final int HeartRate;
  final dynamic time;
}
