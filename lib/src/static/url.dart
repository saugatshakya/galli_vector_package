import 'package:galli_vector_package/galli_vector_package.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class GalliUrl {
  final String imageUrl = "https://image-init.gallimap.com/api/v1";
  final String geoUrl = "https://route-init.gallimap.com";

  String param(String accessToken) => "?accessToken=$accessToken";

  String get360Points(
          LatLng minlatlng, LatLng maxLatlng, zoomLevel, String accessToken) =>
      "/api/v1/streetmarker/${minlatlng.latitude},${minlatlng.longitude}/${maxLatlng.latitude},${maxLatlng.longitude}/$zoomLevel?accessToken=$accessToken";
  String reverseGeoCode(LatLng latLng, String accessToken) =>
      "/api/v1/reverse/generalReverse?accessToken=$accessToken&lat=${latLng.latitude}&lng=${latLng.longitude}";
  String autoComplete(String query, String accessToken, {LatLng? latlng}) =>
      "/api/v1/search/autocomplete?accessToken=$accessToken&word=$query&lat=${latlng == null ? "" : latlng.latitude}&lng=${latlng == null ? "" : latlng.longitude}";
  String search(String place, LatLng latlng, String accessToken) =>
      "/api/v1/search/currentLocation?accessToken=$accessToken&name=$place&currentLat=${latlng.latitude}&currentLng=${latlng.longitude}";
  String getRoute(
          {required LatLng source,
          required LatLng destination,
          required String accessToken}) =>
      "/api/v1/routing?mode=driving&srcLat=${source.latitude}&srcLng=${source.longitude}&dstLat=${destination.latitude}&dstLng=${destination.longitude}&accessToken=$accessToken";
  String get360Image(LatLng latlng,
          {int threshold = 20, required String accessToken}) =>
      "/streetmarker/getnearestimage/${latlng.latitude},${latlng.longitude}/$threshold?accessToken=$accessToken";
  String getNavigation(
          {required LatLng source,
          required LatLng destination,
          required RoutingMethods method,
          required String accessToken}) =>
      "/routingAPI/detailRoute?srcLat=${source.latitude}&srcLng=${source.longitude}&dstLat=${destination.latitude}&dstLng=${destination.longitude}&mode=${method.name}&accessToken=$accessToken";
}

final GalliUrl galliUrl = GalliUrl();
