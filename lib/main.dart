import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Y-Smart',
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  // Couleurs converties depuis les valeurs RGB de ton code React Native
  final Color bgContainer = const Color.fromARGB(255, 220, 218, 213); // rgb(220,218,213)
  final Color firstPartBg = const Color.fromARGB(255, 231, 229, 225); // rgb(231,229,225)
  final Color onBg = const Color.fromARGB(255, 199, 196, 224); // rgb(199,196,224)
  final Color offBg = const Color.fromARGB(255, 218, 197, 193); // rgb(218,197,193)
  final Color indicatorOn = const Color.fromARGB(255, 179, 218, 170); // rgb(179,218,170)
  final Color indicatorOff = const Color.fromARGB(255, 255, 122, 122); // rgb(255,122,122)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgContainer,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Titre principal
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Bienvenue sur Y-Smart !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    backgroundColor: bgContainer,
                  ),
                ),
              ),
              // Première partie (La maison + ON/OFF)
              Container(
                width: 350,
                height: 230,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: firstPartBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // "La maison"
                    Container(
                      width: 200,
                      height: 200,
                      margin: const EdgeInsets.only(top: 15, left: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Text(
                              'La maison',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Arial',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Colonnes ON / OFF
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 90,
                          margin: const EdgeInsets.only(top: 20, left: 5),
                          decoration: BoxDecoration(
                            color: onBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Text(
                                  'ON',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontFamily: 'Arial',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 90,
                          margin: const EdgeInsets.only(top: 10, left: 5),
                          decoration: BoxDecoration(
                            color: offBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Text(
                                  'OFF',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontFamily: 'Arial',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Première rangée de cubes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CubeWidget(
                    label: 'Lampe salon',
                    isOn: true,
                    indicatorOn: indicatorOn,
                    indicatorOff: indicatorOff,
                  ),
                  CubeWidget(
                    label: 'Lampe chambre',
                    isOn: false,
                    indicatorOn: indicatorOn,
                    indicatorOff: indicatorOff,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Deuxième rangée de cubes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CubeWidget(
                    label: 'Lampe bureau',
                    isOn: false,
                    indicatorOn: indicatorOn,
                    indicatorOff: indicatorOff,
                  ),
                  CubeWidget(
                    label: 'Lampe cuisine',
                    isOn: true,
                    indicatorOn: indicatorOn,
                    indicatorOff: indicatorOff,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget pour reproduire un "cube" avec image, libellé et indicateur
class CubeWidget extends StatelessWidget {
  final String label;
  final bool isOn;
  final Color indicatorOn;
  final Color indicatorOff;

  const CubeWidget({
    Key? key,
    required this.label,
    required this.isOn,
    required this.indicatorOn,
    required this.indicatorOff,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              label,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: 'Arial',
              ),
            ),
          ),
          // Indicateur en bas à gauche
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isOn ? indicatorOn : indicatorOff,
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
    );
  }
}
