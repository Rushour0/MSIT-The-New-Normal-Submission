import 'package:flutter/material.dart';
import 'homepage.dart';
import 'requests.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadScreen extends StatefulWidget {
  LoadScreen({Key? key, @required this.name, @required this.pass})
      : super(key: key);
  final name, pass;

  _loadScreenState createState() => _loadScreenState(name, pass);
}

class _loadScreenState extends State<LoadScreen> {
  _loadScreenState(this.name, this.pass);
  final String name, pass;

  getInputs() async {
    if (name == "admin" && pass == "admin") {
      await Future.delayed(const Duration(seconds: 2), () {});
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return HomePage(db: "jatin");
        },
      ));
      return;
    }

    final results = await signIn(name, pass);

    if (results['status']) {
      Navigator.pop(context);

      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return HomePage(db: results['username']);
        },
      ));
      return;
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    getInputs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SpinKitFoldingCube(
                duration: Duration(seconds: 2),
                color: Colors.blue.shade900,
              ),
            ),
            Container(
              child: Text(
                "CoBand",
                style: TextStyle(
                    fontFamily: "Cotton Butter",
                    fontSize: 64,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
            )
          ],
        ),
      ),
    );
  }
}
