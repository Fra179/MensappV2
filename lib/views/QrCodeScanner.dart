import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mensapp_v2/utils/cardutils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;
  final MobileScannerController _controller = MobileScannerController();

  Widget _buildBarcode(Barcode? value) {
    return const Text(
      "Scan your Disco Lazio QR code",
      style: TextStyle(color: Colors.white),
    );
  }

  Future<bool> parseNewData(
    String qrContent,
    MobileScannerController controller,
  ) async {
    var data = await getUserData(qrContent, controller);

    if (data == null) {
      return false;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user-data", jsonEncode(data.toJson()));

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
    }

    return true;
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    var barcode = barcodes.barcodes.firstOrNull;

    if (barcode == null) {
      return;
    }

    var content = barcodes.barcodes.firstOrNull?.displayValue;

    if (content == null) {
      return;
    }

    parseNewData(content, _controller)
        .then((value) {
          if (!value && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error parsing QR code"),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        })
        .onError((e, trace) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple scanner')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcode, controller: _controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
