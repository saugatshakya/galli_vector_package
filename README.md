# galli_vector_package

`galli_vector_package` is a Flutter package for integrating vector maps from Gallimaps into your Flutter applications. This plugin provides an easy way to display and interact with high-quality vector maps.

## Features

- High-performance vector maps
- Map markers, routes, fills and circles
- User interaction handling (e.g., tap, zoom, tilt, pan)
- Automatic map caching for offline

## Installation

Add `galli_vector_package` to your `pubspec.yaml` file:

```yaml
dependencies:
  galli_vector_package: latest
```

Then, run flutter pub get to install the new dependency.

## Usage

Import the plugin in your Dart code:

```dart
import 'package:galli_vector_package/galli_vector_package.dart';
```

## Basic Example

Here is a simple example of how to use the galli_vector_package:

```dart
GalliMap(
            showCurrentLocation: true,
            authToken: "authToken",
            size: (
              height: MediaQuery.of(context).size.height * 2,
              width: MediaQuery.of(context).size.width * 2,
            ),
            compassPosition: (
              position: CompassViewPosition.topRight,
              offset: const Point(32, 82)
            ),
            showCompass: true,
            onMapCreated: (newC) {
              controller = newC;
              setState(() {});
            },
            onMapClick: (LatLng latLng) {

            },
          ),
```

## Documentation

For detailed documentation and advanced usage, please visit the official [documentation](https://gallimaps.com/documentation/flutter-vector-doc.html).
