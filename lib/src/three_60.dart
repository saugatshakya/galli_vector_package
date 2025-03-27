import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class Three60ButtonWidget extends StatefulWidget {
  const Three60ButtonWidget({super.key, required this.controller});
  final MapLibreMapController controller;

  @override
  State<Three60ButtonWidget> createState() => _Three60ButtonWidgetState();
}

class _Three60ButtonWidgetState extends State<Three60ButtonWidget> {
  bool three60lines = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (three60lines) {
          three60lines = false;
          return widget.controller.setLayerVisibility("pano-layer", false);
        } else {
          three60lines = true;
          return widget.controller.setLayerVisibility("pano-layer", true);
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
            Icons.rotate_90_degrees_ccw,
            color: Color(0xff454545),
          ),
        ),
      ),
    );
  }
}
