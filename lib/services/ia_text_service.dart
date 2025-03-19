import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:y_smart_mobile/utils/constants.dart';

class IaTextService {
  Future<String> getIaText({
    required String accessToken,
    required String text,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.API_URL}/text/command'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'text': text,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return data['message'];
      } else {
        print(res);
      }
    } catch (e) {
      print(e);
    }
    return '';
  }
}