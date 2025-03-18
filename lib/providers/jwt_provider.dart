import 'package:flutter/material.dart';
import 'package:y_smart_mobile/models/jwt.dart';

class JwtProvider extends ChangeNotifier {
  Jwt _jwt = Jwt(accessToken: '');

  Jwt get jwt => _jwt;

  void setJwt(String jwt) {
    _jwt = Jwt.fromJson(jwt);
    notifyListeners();
  }

  void setJwtFromModel(Jwt jwt) {
    _jwt = jwt;
    notifyListeners();
  }
}