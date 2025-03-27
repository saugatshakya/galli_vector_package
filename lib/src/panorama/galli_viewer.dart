import 'package:flutter/material.dart';
import 'package:galli_vector_package/src/encryption/encryption.dart';
import 'package:galli_vector_package/src/panorama/panorama.dart';

class GalliViewer extends StatefulWidget {
  final MyBuilder builder;

  final String image;
  final Function(Object? error)? errorBuilder;
  final Function(double? progress)? loadingBuilder;
  final Function(double x, double y, double z)? onTap;
  final Function(double x, double y, double z)? onLongPress;
  final bool addMarkerOnTap;
  final List<Marker> markers;
  final int maxMarkers;
  final bool showClearMarkersButton;
  final bool removeMarkerOnTap;
  final Function(
    double latitude,
    double longitude,
  )? onMarkerTap;

  const GalliViewer({
    super.key,
    required this.builder,
    required this.image,
    this.errorBuilder,
    this.loadingBuilder,
    this.markers = const [],
    this.onTap,
    this.onLongPress,
    this.addMarkerOnTap = true,
    this.maxMarkers = 99,
    this.showClearMarkersButton = true,
    this.removeMarkerOnTap = true,
    this.onMarkerTap,
  });

  @override
  State<GalliViewer> createState() => _GalliViewerState();
}

class _GalliViewerState extends State<GalliViewer> {
  List<Marker> markers = [];

  @override
  void initState() {
    markers = markers + widget.markers;
    setState(() {});
    super.initState();
  }

  clearMarkers() {
    markers = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(context, clearMarkers);
    return ClipRRect(
      child: Panorama(
        sensitivity: 1.4,
        onTap: (longitude, latitude, tilt) {
          if (widget.onTap != null) {
            widget.onTap!(latitude, longitude, tilt);
          }
          if (widget.addMarkerOnTap && markers.length < widget.maxMarkers) {
            markers.add(Marker(
              latitude: latitude,
              longitude: longitude,
              orgin: const Offset(1, 1),
              height: 64,
              widget: GestureDetector(
                onTap: () {
                  if (widget.removeMarkerOnTap) {
                    markers.removeWhere((element) {
                      return element.latitude == latitude &&
                          element.longitude == longitude;
                    });
                  }
                  if (widget.onMarkerTap != null) {
                    widget.onMarkerTap!(latitude, longitude);
                  }
                  setState(() {});
                },
                child: const Icon(
                  Icons.location_on,
                  size: 64,
                  color: Color(0xff212121),
                ),
              ),
              width: 64,
            ));
            setState(() {});
          }
        },
        onLongPressEnd: (longitude, latitude, tilt) {
          if (widget.onLongPress != null) {
            widget.onLongPress!(latitude, longitude, tilt);
          }
        },
        progressBuilder: (double? progress) {
          if (widget.loadingBuilder == null) {
            return Center(
              child: CircularProgressIndicator(
                  value: progress,
                  color: const Color(0xff121212),
                  backgroundColor: Colors.white),
            );
          } else {
            return widget.loadingBuilder!(progress);
          }
        },
        errorBuilder: (Object? error) {
          if (widget.errorBuilder == null) {
            return Center(
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return widget.errorBuilder!(error);
          }
        },
        markers: markers,
        child: Image.network(decrypt(widget.image)),
      ),
    );
  }
}

typedef MyBuilder = void Function(
    BuildContext context, void Function() methodFromChild);
