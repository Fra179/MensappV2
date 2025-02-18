import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:mensapp_v2/utils/cardutils.dart';
import 'package:mensapp_v2/views/AddQrCode.dart';
import 'package:mensapp_v2/views/HomeScreen.dart';
import 'package:mensapp_v2/views/ImportQrCodeScanner.dart';
import 'package:mensapp_v2/views/Info.dart';
import 'package:mensapp_v2/views/LoadingScreen.dart';
import 'package:mensapp_v2/views/QrCodeScanner.dart';
import 'package:mensapp_v2/views/Share.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      handleDeepLink(uri.path.substring(1));
    });
  }

  Future<bool> parseNewData(String qrContent) async {
    var data = await getUserData(qrContent, null);

    if (data == null) {
      return false;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user-data", jsonEncode(data.toJson()));

    _navigatorKey.currentState?.pushNamedAndRemoveUntil("/home", (_) => false);

    return true;
  }

  void handleDeepLink(String base64data) async {
    var strData = utf8.decode(base64Decode(base64data));
    debugPrint(strData);


    parseNewData(strData).then((value) {
      if (!value && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error parsing QR code"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }).onError((e, trace) {
      debugPrint(e.toString());
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid QR code"),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      routes: {
        "/": (context) => const LoadingScreen(),
        "/home": (context) => const HomeScreen(),
        "/add_code": (context) => const AddCodeScreen(),
        "/qr_scanner": (context) => const BarcodeScannerSimple(),
        "/import_qr_scanner": (context) => const ImportBarcodeScanner(),
        "/share": (context) => const Share(),
        "/info": (context) => const InfoScreen(),
        // "/home": (context) => const HomeScreen(),
      },
      initialRoute: "/",
      navigatorKey: _navigatorKey,
    );
  }
}
