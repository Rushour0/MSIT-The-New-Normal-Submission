import 'package:flutter/material.dart';
import 'homepage.dart';
import 'loginpage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatehome();
  }

  // Delay to go to landing page
  _navigatehome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("img/main_icon.png"), context);
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Container(
            height: MediaQuery.of(context).size.width / 2,
            child: Image.asset(
              "img/main_icon.png",
              fit: BoxFit.contain,
            ),
          )),
          Container(
            child: Text(
              "CoBand",
              style: TextStyle(fontFamily: "Cotton Butter", fontSize: 64),
              textAlign: TextAlign.center,
            ),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }
}
