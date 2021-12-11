import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'requests.dart';
import 'loginpage.dart' show LoginPage;

// Initial 0 DateTime Data
List<HeartRateData> hrZero() {
  List<HeartRateData> hrZeroData = [
    HeartRateData(0, DateTime(2000, 01, 01, 0, 0, 0)),
    HeartRateData(0, DateTime(2000, 01, 01, 0, 0, 1)),
    HeartRateData(0, DateTime(2000, 01, 01, 0, 0, 2)),
    HeartRateData(0, DateTime(2000, 01, 01, 0, 0, 3)),
    HeartRateData(0, DateTime(2000, 01, 01, 0, 0, 4)),
    HeartRateData(0, DateTime(2000, 01, 01, 0, 0, 5)),
    HeartRateData(0, DateTime(2000, 01, 01, 0, 0, 6)),
    HeartRateData(0, DateTime(2000, 01, 01, 0, 0, 7)),
    HeartRateData(0, DateTime(2000, 01, 01, 0, 0, 8)),
    HeartRateData(0, DateTime(2000, 01, 01, 0, 0, 9)),
  ];
  return hrZeroData;
}

// Home page of the app
class HomePage extends StatefulWidget {
  final String db;
  final int temperature, age;

  HomePage({Key? key, this.db = "jxtin", this.temperature = 37, this.age = 18})
      : super(key: key);

  @override
  _HomePageState createState() =>
      _HomePageState(this.db, this.temperature, this.age);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.db, this.temperature, this.age);

  // Variables to be accepted
  final String db;
  final int temperature, age;

  // Variables to be used later
  late List<HeartRateData> hrValues;

  late List<HeartCheck> hrParameter;

  late String displayHR;

  late int i;
  late String status_image;
  late String healthStatus;

  @override
  void initState() {
    // Load the data every 1 second
    Timer.periodic(const Duration(seconds: 1), loadChartData);
    i = 0;

    // Get initial data
    hrValues = hrZero();

    hrParameter = [HeartCheck(hrValues)];

    displayHR = "";

    status_image = "optimal.png";
    healthStatus = "You are good to go!";

    // Start the main application
    super.initState();
  }

  // Load data function to update the source of the SFCartesian graph
  void loadChartData(Timer timer) async {
    // Get the database values
    List<HeartRateData> hrTemp = await updateHRBandData(this.db);

    // Update values to the data source of the SFCartesian
    for (int j = 0; j < 10; j++) {
      hrValues.add((hrTemp[j]));
      hrValues.removeAt(0);
    }

    // Update values to the data source of the SfCircular
    HeartCheck newHeart = HeartCheck(hrValues);

    // Set state
    setState(
      () {
        hrParameter.removeAt(0);
        hrParameter.add(newHeart);

        displayHR = hrParameter[0].average.toString();

        if (hrParameter[0].average < 70 || hrParameter[0].average > 115) {
          healthStatus = "Health is not in optimal state";
          status_image = "not_optimal.png";
        } else {
          healthStatus = "You are good to go!";
          status_image = "optimal.png";
        }
      },
    );
  }

  // Setting up title text style
  static const titleStyle =
      TextStyle(fontFamily: "Cotton Butter", fontSize: 72);

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("img/profile_picture.png"), context);
    precacheImage(AssetImage("img/optimal.png"), context);
    precacheImage(AssetImage("img/not_optimal.png"), context);
    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Making 3 tab application
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("CoBand", style: titleStyle),
          centerTitle: true,
        ),
        // Navigation bar configuration
        bottomNavigationBar: Container(
          color: Colors.black,
          child: TabBar(
            labelStyle: TextStyle(fontFamily: "Dandelion", fontSize: 28),
            unselectedLabelStyle:
                TextStyle(fontFamily: "Dandelion", fontSize: 28),
            labelColor: Colors.blueGrey,
            unselectedLabelColor: Colors.grey[700],
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.blue.shade200,
            tabs:
                // Setting up tab visual attributes ( icon )
                <Widget>[
              Tab(
                height: screenHeight / 15,
                icon: Icon(Icons.analytics_outlined),
              ),
              Tab(
                height: screenHeight / 15,
                icon: Icon(Icons.local_activity_outlined),
              ),
              Tab(
                height: screenHeight / 15,
                icon: Icon(Icons.circle_notifications_outlined),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue.shade300),
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 5, color: Colors.blue.shade100),
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset(
                        "img/profile_picture.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 5,
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(
                            "USERNAME",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          title: Text(
                            "$db",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(
                            "AGE",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          title: Text(
                            "$age",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text(
                            "HEARTRATE",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                          title: Text(
                            "$displayHR BPM",
                            style: TextStyle(
                                fontFamily: "Montserrat", fontSize: 20),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.white)),
                    primary: Colors.blue.shade300,
                  ),
                  child: Text(" Log out ",
                      style: TextStyle(
                        fontFamily: "BebasNeue",
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginPage();
                        },
                      ),
                    );
                  },
                ),
                Container(
                  height: 50,
                ),
                Container(
                  child: Text(
                    """By  Rushour0""",
                    style: TextStyle(fontFamily: "Dandelion", fontSize: 36),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content of the tabs
        body: TabBarView(
          children: <Widget>[
            // First tab

            Scaffold(
              backgroundColor: Colors.blue.shade50,
              appBar: AppBar(
                backgroundColor: Colors.blue.shade200,
                centerTitle: true,
                title: Text(
                  "LIVE DATA",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 24),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100,
                          )
                        ],
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      height: screenHeight * 2 / 3,
                      width: screenWidth,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            // The SFCartesian chart
                            child: SfCartesianChart(
                              // Set X axis to DateTime
                              primaryXAxis: DateTimeAxis(
                                  dateFormat: DateFormat('hh:mm:ss')),
                              title: ChartTitle(
                                  text: "Heart Rate",
                                  textStyle: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 28)),
                              // Providing the data source and mapping the data
                              series: <LineSeries<HeartRateData, DateTime>>[
                                LineSeries<HeartRateData, DateTime>(
                                    animationDuration: 0,
                                    dataSource: hrValues,
                                    xValueMapper: (HeartRateData value, _) =>
                                        value.datetime,
                                    yValueMapper: (HeartRateData value, _) =>
                                        value.HeartRate),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Second tab
            Scaffold(
              backgroundColor: Colors.blue.shade50,
              appBar: AppBar(
                backgroundColor: Colors.blue.shade200,
                centerTitle: true,
                title: Text(
                  "HEALTH STATUS",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 24),
                ),
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            child: Text(
                              "Your Organization is COVID proof!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "BebasNeue", fontSize: 32),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight / 15,
                        ),
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Image.asset(
                                  "img/$status_image",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Container(
                                  child: Text(
                                    healthStatus,
                                    style: TextStyle(
                                        fontFamily: "BebasNeue", fontSize: 32),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          child: ListTile(
                            leading: Text(
                              "USERNAME",
                              style: TextStyle(
                                  fontFamily: "BebasNeue", fontSize: 28),
                              textAlign: TextAlign.left,
                            ),
                            title: Text(
                              "$db",
                              style: TextStyle(
                                  fontFamily: "Montserrat", fontSize: 20),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          child: ListTile(
                            leading: Text(
                              "UID",
                              style: TextStyle(
                                  fontFamily: "BebasNeue", fontSize: 28),
                              textAlign: TextAlign.left,
                            ),
                            title: Text(
                              "band-0000",
                              style: TextStyle(
                                  fontFamily: "Montserrat", fontSize: 20),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: screenWidth / 3,
                          child: Image.asset(
                            "img/office.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Third tab
            Scaffold(
              backgroundColor: Colors.blue.shade100,
              appBar: AppBar(
                backgroundColor: Colors.blue.shade200,
                centerTitle: true,
                title: Text(
                  "HEALTH CHECK",
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 24),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: screenHeight * 2 / 3,
                      child: Stack(
                        children: [
                          Container(
                              width: screenWidth,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "Heart Rate",
                                  style: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 32),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          Center(
                            child: Text(
                              """$displayHR
BPM""",
                              style: TextStyle(
                                  fontFamily: "Montserrat", fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SfCircularChart(
                            series: <CircularSeries<HeartCheck, int>>[
                              RadialBarSeries(
                                maximumValue: 200,
                                dataSource: hrParameter,
                                radius: '70%',
                                innerRadius: '80%',
                                xValueMapper: (HeartCheck data, _) =>
                                    data.average,
                                yValueMapper: (HeartCheck data, _) =>
                                    data.average,
                                pointColorMapper: (HeartCheck data, _) =>
                                    data.color,
                                cornerStyle: CornerStyle.bothCurve,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
