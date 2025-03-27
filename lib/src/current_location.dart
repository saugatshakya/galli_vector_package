import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class CurrentLocationWidget extends StatelessWidget {
  const CurrentLocationWidget({super.key, required this.controller});
  final MapLibreMapController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        LatLng? myLocation = await controller.requestMyLocationLatLng();
        if (myLocation != null) {
          controller.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                  target: myLocation, zoom: 16, bearing: 0.0, tilt: 0)),
              duration: const Duration(milliseconds: 1000));
        } else {
          log("Unable to get location data. Check location permission or gps settings");
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffE2DFD2),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xff454545), width: 2),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xff454545).withOpacity(0.2),
                  blurRadius: 3,
                  offset: const Offset(1, 1),
                  spreadRadius: 3),
              BoxShadow(
                  color: const Color(0xff454545).withOpacity(0.2),
                  blurRadius: 3,
                  offset: const Offset(-1, -1),
                  spreadRadius: 3)
            ]),
        width: 48,
        height: 48,
        child: const Center(
          child: Icon(
            Icons.location_searching_outlined,
            color: Color(0xff454545),
          ),
        ),
      ),
    );
  }
}
