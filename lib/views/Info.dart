import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mensapp V2",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Mensapp V2",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text("Versione 2.0.0b"),
            SizedBox(height: 32),
            CircleAvatar(
              backgroundImage: AssetImage("assets/icon/yai.jpeg"),
              radius: 55,
            ),
            SizedBox(height: 32),
            RichText(text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: [
                TextSpan(text: "Made by "),
                TextSpan(text: "Francesco De Benedittis", style: TextStyle(fontWeight: FontWeight.bold)),
              ]
            )),
            GestureDetector(
              child: Text("francescodb.me", style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 15
              ),),
              onTap: () {
                launchUrl(Uri.parse("https://francescodb.me"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
