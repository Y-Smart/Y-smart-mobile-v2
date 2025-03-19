import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:y_smart_mobile/models/device.dart';
import 'package:y_smart_mobile/providers/jwt_provider.dart';
import 'package:y_smart_mobile/services/devices_service.dart';
import 'package:y_smart_mobile/utils/colors.dart';
import 'package:y_smart_mobile/utils/constants.dart';
import 'package:y_smart_mobile/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DevicesService _devicesService = DevicesService();
  late String accessToken;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  bool _speechEnabled = false;

  List<Device> _devices = [];
  bool _isLoading = true;

  late MqttServerClient client;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    accessToken =
        Provider.of<JwtProvider>(context, listen: false).jwt.accessToken;
    getDevices();
  }

  void getDevices() async {
    final devices = await _devicesService.getDevices(accessToken: accessToken);

    if (!mounted) return;

    setState(() {
      _devices = devices;
      _isLoading = false;
    });

    _connectMQTT();
  }

  _connectMQTT() async {
    client = MqttServerClient(Constants.MQTT_URL, 'flutter_client_1');
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client_1')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Erreur de connexion: $e');
      client.disconnect();
    }
  }

  void _onDisconnected() {
    print('Déconnecté du broker');
  }

  void _onSubscribed(String topic) {
    print('Abonné à $topic');
  }

  void _onConnected() {
    print('Connecté au broker');

    for (final device in _devices) {
      final topic = device.id;
      client.subscribe(topic, MqttQos.atMostOnce);
      print('Souscription à $topic');
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final MqttPublishMessage recMessage =
          messages[0].payload as MqttPublishMessage;
      final String payload = MqttPublishPayload.bytesToStringAsString(
        recMessage.payload.message,
      );
      final topic = messages[0].topic;

      final Map<String, dynamic> jsonData = jsonDecode(payload);
      final String state = jsonData['data'];

      setState(() {
        final deviceIndex = _devices.indexWhere((device) => device.id == topic);
        _devices[deviceIndex] = _devices[deviceIndex].copyWith(state: state);
      });

      print("Message reçu: $state de $topic");
    });
  }

  Future<void> _initSpeech() async {
    bool available = false;

    try {
      available = await _speech.initialize(
        onError: (error) => print('Speech error: ${error.errorMsg}'),
        onStatus: (status) => print('Speech status: $status'),
      );
    } catch (e) {
      print('Error initializing speech: $e');
    }

    if (!mounted) return;

    if (!available) {
      showSnackBar(
        context,
        "Le micro n'est pas disponible. Vérifiez les permissions.",
      );
    }

    setState(() {
      _speechEnabled = available;
    });
  }

  void _listen() async {
    if (!_speechEnabled) {
      showSnackBar(
        context,
        "La reconnaissance vocale n'est pas disponible. Vérifiez les permissions.",
      );
      return;
    }

    if (!_isListening) {
      final bool available = await _speech.initialize(
        onStatus: (String status) => print('onStatus: $status'),
        onError: (dynamic error) => print('onError: $error'),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult:
              (val) => setState(() {
                _text = val.recognizedWords;
              }),
        );
      } else {
        showSnackBar(context, "Erreur lors de l'activation du micro.");
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgContainer,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bienvenue',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _text,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.firstPartBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Container(
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(
                              16,
                            ), // Ajout d'un padding pour l'esthétique
                            child: Center(
                              child: Text(
                                "Gérer votre maison à l'aide des commandes vocales",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                      children:
                          _devices
                              .map(
                                (device) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: CubeWidget(
                                    type: device.type,
                                    location: device.location,
                                    isOn: device.state == 'on',
                                  ),
                                ),
                              )
                              .toList(),
                    ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Colors.redAccent,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}

class CubeWidget extends StatelessWidget {
  final String type;
  final String location;
  final bool isOn;

  const CubeWidget({
    Key? key,
    required this.type,
    required this.location,
    required this.isOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSnackBar(
          context,
          'Device: $type at $location is ${isOn ? 'On' : 'Off'}',
        );
      },
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Image positionnée (n'oublie pas d'ajouter l'image "lampe.jpg" dans ton dossier assets et de le déclarer dans pubspec.yaml)
            Positioned(
              top: 40,
              left: 50,
              child: Container(
                width: 80, // Ajuster si besoin
                height: 80,
              ),
            ),
            // Libellé en haut à gauche
            Positioned(
              top: 10,
              left: 10,
              child: Text(
                type,
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Positioned(
              top: 50,
              left: 10,
              child: Text(
                location,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isOn ? AppColors.indicatorOn : AppColors.indicatorOff,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    '💡',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
