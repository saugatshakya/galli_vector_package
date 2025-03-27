import 'dart:developer';

import 'package:galli_vector_package/src/api/galli_api.dart';
import 'package:galli_vector_package/src/encryption/encryption.dart';
import 'package:galli_vector_package/src/static/url.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

enum Three60Type { focused, near }

enum RoutingMethods { driving, cycling, walking }

class GalliMethods {
  final String accessToken;
  GalliMethods(this.accessToken);
  Future autoComplete(String query, LatLng location) async {
    log("location: $location");
    var response = await geoApi.get(
        galliUrl.autoComplete(query, accessToken, latlng: location),
        accessToken);

    return response;
  }

  Future search(String query, LatLng location) async {
    var response = await geoApi.get(
        galliUrl.search(
            query, LatLng(location.latitude, location.longitude), accessToken),
        accessToken);
    return response;
  }

  Future reverse(LatLng latLng) async {
    var response = await geoApi.get(
        galliUrl.reverseGeoCode(latLng, accessToken), accessToken);

    return response;
  }

  Future getRoute({
    required LatLng source,
    required LatLng destination,
  }) async {
    var response = await geoApi.get(
        galliUrl.getRoute(
            source: source, destination: destination, accessToken: accessToken),
        accessToken);

    return response;
  }

  Future get360Image(LatLng latlng, {int threshold = 20}) async {
    var three60Image = await imageApi.get(
        galliUrl.get360Image(latlng,
            threshold: threshold, accessToken: accessToken),
        accessToken);
    if (three60Image != null) {
      String imageUrl = three60Image["data"]["imgurl"];
      return encrypt(imageUrl);
    } else {
      return null;
    }
  }

  getNavigationData(
      {required LatLng source,
      required LatLng destination,
      required RoutingMethods method}) async {
    var response = await geoApi.get(
        galliUrl.getNavigation(
            source: source,
            destination: destination,
            method: method,
            accessToken: accessToken),
        accessToken);
    return response;
  }

  // Future animateMapMove(LatLng destLocation, double destZoom, vsync, mounted,
  //     mapController) async {
  //   if (!mounted) return;
  //   final latTween = Tween<double>(
  //       begin: mapController.center.latitude, end: destLocation.latitude);
  //   final lngTween = Tween<double>(
  //       begin: mapController.center.longitude, end: destLocation.longitude);
  //   final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);
  //   if (!mounted) return;
  //   var controller = AnimationController(
  //       duration: const Duration(milliseconds: 1000), vsync: vsync);
  //   Animation<double> animation =
  //       CurvedAnimation(parent: controller, curve: Curves.decelerate);
  //   controller.addListener(() {
  //     mapController.move(
  //         LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
  //         zoomTween.evaluate(animation));
  //   });
  //   animation.addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       controller.dispose();
  //     } else if (status == AnimationStatus.dismissed) {
  //       controller.dispose();
  //     }
  //   });
  //   await controller.forward();
  // }

  // rotateMap(vsync, mounted, MapController mapController) async {
  //   if (!mounted) return;

  //   final rotateTween = Tween<double>(begin: mapController.rotation, end: 0.0);
  //   if (!mounted) return;
  //   var controller = AnimationController(
  //       duration: const Duration(milliseconds: 1000), vsync: vsync);
  //   Animation<double> animation =
  //       CurvedAnimation(parent: controller, curve: Curves.decelerate);
  //   controller.addListener(() {
  //     mapController.rotate(rotateTween.evaluate(animation));
  //   });
  //   animation.addStatusListener((status) {
  //     if (status == AnimationStatus.completed) {
  //       controller.dispose();
  //     } else if (status == AnimationStatus.dismissed) {
  //       controller.dispose();
  //     }
  //   });
  //   await controller.forward();
  // }
}
