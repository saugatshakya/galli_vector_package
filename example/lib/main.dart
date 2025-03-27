import 'package:flutter/material.dart';
import 'package:galli_vector_package/galli_vector_package.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> getLocation() async {
    LocationPermission permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.denied ||
        permissionStatus == LocationPermission.deniedForever) {
      permissionStatus = await Geolocator.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          body: SafeArea(
        child: FutureBuilder(
            future: getLocation(),
            builder: (context, snap) {
              return GalliMap(
                size: (
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height
                ),
                showCurrentLocation: false,
                authToken: "349ebf7c-9980-483d-8b16-6b193617ed52",
              );
            }),
      )),
    );
  }
}
