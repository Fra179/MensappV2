import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Share extends StatefulWidget {
  const Share({super.key});

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  bool _showWarning = true;
  String userData = "";

  void initUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = prefs.getString("user-data") ?? "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUserData();
  }

  Widget buildWarning(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "[!] WARNING [!]",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            child: Text(
              "Please note that sharing your QR code is not recommended, the other person will be able to use the QR Code as if it was you. Remember that you only have 2 daily usages for each QR Code. Don't share it with anyone that you don't know and that you can't beat up in person",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),
          MaterialButton(
            onPressed: () {
              setState(() {
                _showWarning = false;
              });
            },
            color: Colors.red,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "I understand",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNormal(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImageView(data: userData, size: 350),
          SizedBox(height: 16),
          SizedBox(
            width: 350,
            child: Text(
              "Scan this QR code to share your data",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          'Mensapp V2',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _showWarning ? buildWarning(context) : buildNormal(context),
    );
  }
}
