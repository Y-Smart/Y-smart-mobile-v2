import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:y_smart_mobile/providers/jwt_provider.dart';
import 'package:y_smart_mobile/screens/home_screen.dart';
import 'package:y_smart_mobile/screens/signin_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => JwtProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YSmart',
      debugShowCheckedModeBanner: false,
      home: Provider.of<JwtProvider>(context).jwt.accessToken.isEmpty ? const SignInScreen() : const HomeScreen(),
    );
  }
}
