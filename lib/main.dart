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
  // Couleurs converties depuis les valeurs RGB de ton code React Native
  final Color bgContainer = const Color.fromARGB(
    255,
    220,
    218,
    213,
  ); // rgb(220,218,213)
  final Color firstPartBg = const Color.fromARGB(
    255,
    231,
    229,
    225,
  ); // rgb(231,229,225)
  final Color onBg = const Color.fromARGB(
    255,
    199,
    196,
    224,
  ); // rgb(199,196,224)
  final Color offBg = const Color.fromARGB(
    255,
    218,
    197,
    193,
  ); // rgb(218,197,193)
  final Color indicatorOn = const Color.fromARGB(
    255,
    179,
    218,
    170,
  ); // rgb(179,218,170)
  final Color indicatorOff = const Color.fromARGB(
    255,
    255,
    122,
    122,
  ); // rgb(255,122,122)

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
