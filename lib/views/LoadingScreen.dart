import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  Future<void> loadData(BuildContext context) async {
    var sharedPrefs = await SharedPreferences.getInstance();

    // Load data from shared preferences
    var secretKey = sharedPrefs.getString("user-data");
    if (secretKey != null) {
      if (context.mounted) {
        print("SECRET: $secretKey");
        Navigator.pushReplacementNamed(context, "/home");
      }
    } else {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, "/add_code");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData(context);
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
