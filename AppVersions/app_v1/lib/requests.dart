import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Global variables
final String apiKeyCloudant = "iTKNYiDWhOhM71Ay-q1faeu1Zp2U0u8jyrm-h2juXyyJ";
final String dbURL =
    "https://dbb024f3-9e7d-44fd-b99c-cbcdb456cc83-bluemix.cloudantnosqldb.appdomain.cloud";

// Heart rate data class
class HeartRateData {
  HeartRateData(this.HeartRate, this.datetime);
  final int HeartRate;
  final DateTime datetime;
}

// Heart check calculation class
class HeartCheck {
  final List<HeartRateData> data;
  late int average;
  late Color color;

  // Constructor
  HeartCheck(this.data) {
    this.calculate();
    if (this.average < 70 || this.average > 115)
      color = const Color.fromRGBO(128, 0, 0, 1);
    else
      color = const Color.fromRGBO(0, 128, 0, 1);
  }

  // Calculate the health check parameter for a set of readings
  calculate() {
    int sum = 0;
    for (int count = 0; count < data.length; count++)
      sum += data[count].HeartRate;
    // Get the average
    average = sum ~/ data.length;
  }
}

// Get IAM token
Future<String> getIAMToken(String IAM_api_key) async {
  // App ID
  // String IAM_api_key = "tLOwENvsRilIiE2wE_ETNYay0MMDK0N2vJWXoMe-5hjO";

  // Cloudant
  // String IAM_api_key = "9jtFMX0LC5cab8x5I5OYermeMeDYf0hQKCegLnT0z50L";
  final response = await http.post(
      Uri.parse('https://iam.cloud.ibm.com/identity/token'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      },
      body:
          "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=$IAM_api_key");

  final responseJson = jsonDecode(response.body);
  return responseJson['access_token'];
}

// Get document specific data from a db
Future<Map<String, dynamic>> fetchDocDB(String db, String doc_id) async {
  final String IAM_Token = await getIAMToken(apiKeyCloudant);

  final response =
      await http.get(Uri.parse('$dbURL/$db/$doc_id'), headers: <String, String>{
    HttpHeaders.authorizationHeader: "Bearer $IAM_Token",
    HttpHeaders.contentTypeHeader: 'application/json',
  });

  final responseJson = jsonDecode(response.body);

  return responseJson;
}

// Get data from cloudant
Future<Map<String, dynamic>> fetchCloudantData(String db) async {
  final String IAM_Token = await getIAMToken(apiKeyCloudant);

  final response = await http.post(Uri.parse('$dbURL/$db/_all_docs'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: "Bearer $IAM_Token",
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "include_docs": true,
        "descending": true,
        "limit": 10,
      }));

  final responseJson = jsonDecode(response.body);

  return responseJson;
}

// Process the rows
Future<List<HeartRateData>> updateHRBandData(String db) async {
  Map<String, dynamic> responseJson = await fetchCloudantData(db);
  List<HeartRateData> hrValues = [];
  final allRows = responseJson['rows'];

  for (var i = 9; i > -1; i--) {
    hrValues.add(HeartRateData(allRows[i]['doc']['value'],
        DateFormat("dd/MM/yy hh:mm:ss").parse(allRows[i]['key'])));
  }
  return hrValues;
}

// Check db existence
Future<bool> checkDB(String dbName, String IAM_Token) async {
  final response = await http.get(Uri.parse('$dbURL/$dbName'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $IAM_Token"});

  print(response.statusCode);
  return (response.statusCode.toString() == '200');
}

// Create a new db via request
Future<bool> createDB(String dbName, String IAM_Token) async {
  final response = await http.get(Uri.parse('$dbURL/$dbName'),
      headers: {HttpHeaders.authorizationHeader: "Bearer $IAM_Token"});

  return (response.statusCode.toString() == '201');
}

// Add to the key_pass db
Future<bool> addToKEY_PASS(
    String dbName, String age, String password, String IAM_Token) async {
  final response = await http.put(Uri.parse('$dbURL/$dbName'), headers: {
    HttpHeaders.authorizationHeader: "Bearer $IAM_Token",
    HttpHeaders.contentTypeHeader: "application/json"
  }, body: <String, dynamic>{
    "username": dbName,
    "age": age,
    "password": password
  });

  return (response.statusCode.toString() == '201');
}

// Sign up function for the user
Future<bool> signUp(String dbName, String age, String password) async {
  final String IAM_Token = await getIAMToken(apiKeyCloudant);

  // Check if new database is created
  bool dbCreated = await createDB(dbName, IAM_Token);

  // Return false if new database is not created
  if (!dbCreated) return false;

  // Add attributes to the created database
  return await addToKEY_PASS(dbName, age, password, IAM_Token);
}

Future<Map<String, dynamic>> signIn(String dbName, String password) async {
  late Map<String, dynamic> results;
  final String IAM_Token = await getIAMToken(apiKeyCloudant);

  if (!(await checkDB(dbName, IAM_Token))) {
    return {"status": false, 'reason': 'error'};
  }
  // Get the database's data
  Map<String, dynamic> logInCheck = await fetchDocDB("key_pass", dbName);

  if (password != logInCheck['password']) {
    return {"status": false, 'reason': 'password'};
  }

  // Clean and give data
  results = {
    "status": true,
    "username": dbName,
  };
  return results;
}
