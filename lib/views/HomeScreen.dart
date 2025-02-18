import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mensapp_v2/utils/cardutils.dart';
import 'package:mensapp_v2/utils/title_case.dart';
import 'package:otp/otp.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _generatedTotp = "";
  String _user = "";

  void startTotpGeneration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString("user-data");

    if (userDataString == null) {
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed("/");
      }
      return;
    }

    var userData = UserData.fromJson(jsonDecode(userDataString));

    var generatedTotp = OTP.generateTOTPCodeString(
      userData.cardData.cardSecret,
      DateTime
          .now()
          .millisecondsSinceEpoch +
          userData.cardData.cardInterval * 1000,
      interval: userData.cardData.cardInterval,
      algorithm: Algorithm.SHA256,
      length: 6,
      isGoogle: true,
    );

    _user = "${userData.name} ${userData.lastName}".toTitleCase();

    // start periodic update
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        generatedTotp = OTP.generateTOTPCodeString(
          userData.cardData.cardSecret,
          DateTime
              .now()
              .millisecondsSinceEpoch +
              userData.cardData.cardInterval * 1000,
          interval: userData.cardData.cardInterval,
          algorithm: Algorithm.SHA1,
          length: 6,
          isGoogle: false,
        );
        _generatedTotp = userData.cardData.cardId.replaceFirst(
          "0000000",
          generatedTotp,
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTotpGeneration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(0),
        color: Colors.white,
        height: 25,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 1)),
          ),
          child: Center(
            child: Text(
              "In onore di Fra ingiustamente avvelenato",
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Mensapp V2',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (String value) async {
              if (value == "share") {
                Navigator.of(context).pushNamed("/share");
              } else if (value == "logout") {
                // ask for confirmation
                showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                ).then((value) {
                  if (value == true && context.mounted) {
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.remove("user-data");
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil("/", (route) => false);
                    });
                  }
                });
              } else {
                Navigator.of(context).pushNamed("/info");
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "share",
                  child: const Text("Share"),
                ),
                PopupMenuItem(value: "info", child: const Text("Info")),
                PopupMenuItem<String>(
                  value: "logout",
                  child: const Text("Logout"),
                ),
              ];
            },
            iconColor: Colors.white,
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_user),
            SizedBox(height: 16),
            QrImageView(data: _generatedTotp, size: 350),
            SizedBox(height: 16),
            SizedBox(
              width: 350,
              child: Text(
                "Scannerizza questo QR code all'entrata della mensa e spera che il cibo sia commestibile :P",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
