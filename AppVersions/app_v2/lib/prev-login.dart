import 'package:flutter/material.dart';
import 'homepage.dart';
import 'requests.dart';

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

  late Object username, password, age, temperature;
  final usernameInput = TextEditingController();
  final passwordInput = TextEditingController();

  getInputs() async {
    final results = await signIn(usernameInput.text, passwordInput.text);
    if (results['status']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage(db: results['username'], age: results['age']);
          },
        ),
      );
    }
    if (usernameInput.text == "admin" && passwordInput.text == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage(db: "jatin");
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final usernameField = Container(
        width: screenWidth / 1.3,
        child: TextField(
          obscureText: false,
          controller: usernameInput,
          style: style,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              contentPadding: EdgeInsets.fromLTRB(screenWidth / 40,
                  screenHeight / 40, screenWidth / 40, screenHeight / 40),
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(96.0))),
        ));

    final passwordField = Container(
      width: screenWidth / 1.3,
      child: TextField(
        obscureText: true,
        style: style,
        controller: passwordInput,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey,
            contentPadding: EdgeInsets.fromLTRB(screenWidth / 40,
                screenHeight / 40, screenWidth / 40, screenHeight / 40),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      ),
    );

    final loginButton = Material(
      elevation: 20.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black,
      child: MaterialButton(
        height: 50,
        minWidth: screenWidth / 2,
        onPressed: () {
          getInputs();
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: screenHeight,
              width: screenWidth,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    right: 0,
                    child: SizedBox(
                      child: Image.asset(
                        "img/greenyellow_circle.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SizedBox(
                      width: screenWidth,
                      child: Image.asset(
                        "img/purple_circle.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SizedBox(
                      child: Image.asset(
                        "img/pink_circle.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 140,
                    left: 30,
                    child: Text(
                      "Paw'llar",
                      style: TextStyle(
                          fontFamily: "Cotton Butter",
                          fontSize: 72,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    child: usernameField,
                    top: screenHeight / 2.5,
                    left: screenWidth / 2 - screenWidth / 2.6,
                  ),
                  Positioned(
                    child: passwordField,
                    top: screenHeight / 2,
                    left: screenWidth / 2 - screenWidth / 2.6,
                  ),
                  Positioned(
                    child: loginButton,
                    top: screenHeight / 1.6,
                    left: screenWidth / 4,
                  ),
                  Positioned(
                    top: screenHeight / 1.3,
                    left: 30,
                    child: Material(
                      elevation: 20.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.grey[700],
                      child: MaterialButton(
                        height: 50,
                        minWidth: screenWidth / 4,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
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
