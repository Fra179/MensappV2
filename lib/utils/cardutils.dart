import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

import 'names_list.dart';

class CardData {
  final String sessionId;
  final String sessionKey;
  final String codapp;
  final String cardId;
  final String cardSecret;
  final int cardInterval;

  CardData({
    required this.sessionId,
    required this.sessionKey,
    required this.codapp,
    required this.cardId,
    required this.cardSecret,
    required this.cardInterval,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'sessionKEY': sessionKey,
      'codapp': codapp,
      'cardid': cardId,
      'cardsecret': cardSecret,
      'cardinterval': cardInterval,
    };
  }

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      sessionId: json['sessionId'],
      sessionKey: json['sessionKEY'],
      codapp: json['codapp'],
      cardId: json['cardid'],
      cardSecret: json['cardsecret'],
      cardInterval: json['cardinterval'],
    );
  }
}

class UserData {
  final String name;
  final String lastName;
  final CardData cardData;

  UserData({
    required this.name,
    required this.lastName,
    required this.cardData,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'lastName': lastName, 'cardData': cardData.toJson()};
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      lastName: json['lastName'],
      cardData: CardData.fromJson(json['cardData']),
    );
  }

  static UserData? fromOfficialJson(Map<String, dynamic> json) {
    var cardDataStr = json['jwt'].split(".");
    if (cardDataStr.length != 3) {
      return null;
    }
    var cardData = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(cardDataStr[1]))),
    );

    return UserData(
      name: json['first_name'],
      lastName: json['last_name'],
      cardData: CardData.fromJson(cardData['public']),
    );
  }
}

Future<UserData?> getUserData(String qrContent, MobileScannerController? controller) async {
  if (controller != null) {
    await controller.stop();
  }

  final data = jsonDecode(qrContent);
  final callbackUrl = data['url'];
  final key = data['key'];
  // final info = data['info'];

  var res = await http.post(
    Uri.parse(callbackUrl),
    headers: {'authorization': 'Bearer cbf23b95-e56d-4494-830e-f4b8594a3704', 'content-type': 'application/json'},
    body: json.encode({
      'KEY': key,
      'DEVICE_UID': 'N/A',
      'DEVICE_NAME':
          'Samsung Galaxy Sirda di ${names[Random().nextInt(names.length)]}',
      'DEVICE_OS': "Android",
      'DEVICE_VERSION': '35',
      'APP_NAME': 'DiSCo MensaApp',
      'APP_VER': '2.5.11',
    }),
  );

  if (res.statusCode != 200) {
    throw Exception('Failed to post data: ${res.statusCode} ${res.body}');
  }

  var respData = jsonDecode(res.body);

  if (respData['status'] != 'OK') {
    throw Exception('Failed to post data: ${respData['error']}');
  }

  var rawCardData = respData['data'];

  return UserData.fromOfficialJson(rawCardData);
}
