import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:galli_vector_package/src/api/methods.dart';
import 'package:galli_vector_package/src/current_location.dart';
import 'package:galli_vector_package/src/search.dart';
import 'package:galli_vector_package/src/three_60.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class GalliMap extends StatefulWidget {
  final ({double height, double width}) size;
  final bool showCurrentLocation;
  final bool showCompass;
  final bool showCurrentLocationButton;
  final bool showSearchWidget;
  final bool showThree60Widget;
  final ({CompassViewPosition? position, Point<num>? offset}) compassPosition;
  final Function(MapLibreMapController controller)? onMapCreated;
  final Function(LatLng latlng)? onMapClick;
  final CameraPosition? initialCameraPostion;
  final Function(UserLocation location)? onUserLocationChanged;
  final String authToken;
  final MinMaxZoomPreference minMaxZoomPreference;
  final bool doubleClickZoomEnabled;
  final bool dragEnabled;
  final bool rotateGestureEnabled;
  final bool zoomGestureEnabled;
  final bool tiltGestureEnabled;
  final bool scrollGestureEnabled;
  final Function(LatLng latLng)? onMapLongPress;
  final List<Widget> children;

  const GalliMap(
      {super.key,
      this.showCurrentLocation = true,
      this.showCompass = true,
      this.showSearchWidget = true,
      this.showThree60Widget = true,
      this.compassPosition = (
        position: CompassViewPosition.bottomRight,
        offset: const Point(30, 48)
      ),
      this.showCurrentLocationButton = true,
      this.onMapCreated,
      this.onMapClick,
      required this.size,
      this.initialCameraPostion,
      this.minMaxZoomPreference = const MinMaxZoomPreference(4.5, 22),
      this.zoomGestureEnabled = true,
      this.doubleClickZoomEnabled = true,
      this.dragEnabled = true,
      required this.authToken,
      this.onUserLocationChanged,
      this.tiltGestureEnabled = true,
      this.scrollGestureEnabled = true,
      this.rotateGestureEnabled = true,
      this.onMapLongPress,
      this.children = const []});

  @override
  State<GalliMap> createState() => _GalliMapState();
}

class _GalliMapState extends State<GalliMap> {
  late GalliMethods galliMethods;

  @override
  void initState() {
    galliMethods = GalliMethods(widget.authToken);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Stack(children: [
        ClipRRect(
          child: Transform.scale(
            scale: 1,
            child: MapLibreMap(
                minMaxZoomPreference: widget.minMaxZoomPreference,
                doubleClickZoomEnabled: widget.doubleClickZoomEnabled,
                dragEnabled: widget.dragEnabled,
                rotateGesturesEnabled: widget.rotateGestureEnabled,
                zoomGesturesEnabled: widget.zoomGestureEnabled,
                tiltGesturesEnabled: widget.tiltGestureEnabled,
                scrollGesturesEnabled: widget.scrollGestureEnabled,
                onMapLongClick: (Point<num> data, LatLng latlng) {
                  if (widget.onMapLongPress != null) {
                    widget.onMapLongPress!(latlng);
                  }
                },
                onMapCreated: (c) async {
                  controller = c;
                },
                onStyleLoadedCallback: () {
                  if (widget.onMapCreated != null) {
                    widget.onMapCreated!(controller!);
                  }
                  if (widget.initialCameraPostion != null &&
                      widget.showCurrentLocation) {
                    controller!.animateCamera(CameraUpdate.newCameraPosition(
                        widget.initialCameraPostion!));
                    controller!.animateCamera(CameraUpdate.zoomTo(16));
                  }
                  setState(() {});
                },
                onMapClick: (point, coordinates) async {
                  if (widget.onMapClick != null) {
                    widget.onMapClick!(coordinates);
                  }
                },
                trackCameraPosition: true,
                myLocationEnabled: widget.showCurrentLocation,
                myLocationRenderMode: widget.showCurrentLocation
                    ? MyLocationRenderMode.compass
                    : MyLocationRenderMode.normal,
                myLocationTrackingMode: widget.showCurrentLocation
                    ? MyLocationTrackingMode.tracking
                    : MyLocationTrackingMode.none,
                compassEnabled: widget.showCompass,
                compassViewPosition: widget.compassPosition.position,
                compassViewMargins: widget.compassPosition.offset,
                onUserLocationUpdated: (UserLocation location) {
                  if (widget.onUserLocationChanged != null) {
                    widget.onUserLocationChanged!(location);
                  }
                },
                styleString:
                    "https://map-init.gallimap.com/styles/light/style.json?accessToken=${widget.authToken}",
                initialCameraPosition: widget.initialCameraPostion ??
                    const CameraPosition(
                        target: LatLng(
                          27.677120,
                          85.322313,
                        ),
                        zoom: 18,
                        bearing: 0.0,
                        tilt: 0)),
          ),
        ),
        Positioned(
            bottom: 4,
            left: 8,
            child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.centerLeft,
                child: Image.network(
                  "https://gallimaps.com/images/logo2.png",
                  colorBlendMode: BlendMode.srcIn,
                  color: const Color(0Xff812C19),
                  fit: BoxFit.contain,
                ))),
        if (controller != null && widget.showCurrentLocationButton)
          Positioned(
              bottom: 16,
              right: 16,
              child: CurrentLocationWidget(
                controller: controller!,
              )),
        if (controller != null && widget.showThree60Widget)
          Positioned(
              bottom: 73,
              right: 16,
              child: Three60ButtonWidget(controller: controller!)),
        if (controller != null && widget.showSearchWidget)
          GalliSearchWidget(
            width: widget.size.width * 0.9,
            authToken: widget.authToken,
            mapController: controller!,
          ),
        for (Widget widget in widget.children) widget
      ]),
    );
  }
}

MapLibreMapController? controller;
