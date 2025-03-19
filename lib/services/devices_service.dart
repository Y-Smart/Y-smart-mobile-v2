import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:y_smart_mobile/models/device.dart';
import 'package:y_smart_mobile/utils/constants.dart';

class DevicesService {
  Future<List<Device>> getDevices({
    required String accessToken,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${Constants.API_URL}/devices'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print(res.body);

      if (res.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(res.body);
        return jsonData.map((device) => Device.fromJson(device)).toList();
      } else {
        print(res);
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  changeDeviceState({
    required String deviceId,
    required String state,
    required String accessToken,
  }) async {
    try {
      final res = await http.put(
        Uri.parse('${Constants.API_URL}/click/command/$deviceId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, String>{
          'state': state,
        }),
      );
      
      print(res);
    } catch (e) {
      print(e);
    }
  }
}