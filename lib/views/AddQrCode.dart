import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mensapp_v2/components/HugeButton.dart';

class AddCodeScreen extends StatefulWidget {
  const AddCodeScreen({super.key});

  @override
  State<AddCodeScreen> createState() => _AddCodeScreenState();
}

class _AddCodeScreenState extends State<AddCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Mensapp!",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text("Select an option below to start scanning QR codes."),

            SizedBox(height: 48),

            HugeButtonWithIcon(
              image: SvgPicture.asset("assets/svg/qr-code.svg", width: 80),
              title: "Scan QR Code",
              description: "Scan a QR Code generated  from laziodisco.it",
              onClick: () => Navigator.pushNamed(context, "/qr_scanner"),
            ),
            SizedBox(height: 16),
            HugeButtonWithIcon(
              image: Icon(
                Icons.phone_android,
                color: Color(0xff1970B7),
                size: 80,
              ),
              title: "Import QR Code",
              description: "Import an existing code from another Mensapp user",
              onClick: () => Navigator.pushNamed(context, "/import_qr_scanner"),
            ),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
